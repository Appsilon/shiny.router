# End-to-end tests

Browser tests for shiny.router, written with [Playwright](https://playwright.dev). They start real Shiny
apps that use the package **built from this checkout** and drive them in Chromium.

This folder is excluded from the package build (`.Rbuildignore`), so `R CMD check` and CRAN never see it.

## Running

Prerequisites: R with the package's dependencies installed (`shiny` etc.) plus the packages in `Config/Needs/e2e`
in `DESCRIPTION` (e.g. `pak::local_install_deps(dependencies = "Config/Needs/e2e")`), and Node.js 20 or newer.

```sh
cd tests/e2e
npm ci                               # first time, or after package-lock.json changes
npx playwright install chromium      # first time, or after upgrading @playwright/test
npm test                             # run everything
```

Useful variants:

| Command | What it does |
|---|---|
| `npm test -- specs/routing.spec.ts` | Run one file |
| `npm test -- -g "deep link"` | Run tests whose title matches |
| `npm run test:ui` | Interactive UI mode: watch, time-travel, pick locators |
| `npm test -- --headed --debug` | Step through a test in a visible browser |
| `npm run report` | Open the HTML report of the last run |
| `npx playwright show-trace test-results/<test>/trace.zip` | Inspect a failed test's trace |

When a test fails, its folder in `test-results/` holds a screenshot, a trace, and `app.log` with the app's R
output. An app can serve several tests, so the log marks the line where the failed test started. (If the app
fails to start, there is no `app.log`: the error message includes the R output.)

To run against another Shiny version, install it into a separate library and put that library on `R_LIBS`, e.g.
`R_LIBS=/path/to/shiny-1.7.5.1-lib npm test`.

### In CI

`.github/workflows/e2e.yml` runs `npm test` on ubuntu, once with the oldest Shiny version we test (1.7.5.1) and
once with the current CRAN release. It runs only when the package, the examples or the e2e tests change. In CI
the tests use the Google Chrome that comes with the GitHub runner (`CI` is set), not Playwright's own Chromium:
that avoids installing browser system packages on every run. To reproduce CI locally with your own Chrome, run
`CI=1 npm test`. If tests fail, download the `e2e-shiny-<version>` artifact: it holds the HTML report and, per
failed test, the trace and `app.log`. If the job fails in an earlier step (e.g. while installing R), there is no
artifact; read the job log.

## How it works

1. **Install from source.** Before the tests start, `harness/global-setup.ts` runs `R CMD INSTALL` into
   a temporary library, one per run. Every app process puts that library first on its library path (and stops
   if the package would load from anywhere else), so `library(shiny.router)` always loads the code in your working
   tree. You never need to reinstall the package by hand. Exception: UI mode (`npm run test:ui`) installs once
   when it starts, so restart it after changing the package.
2. **One R process per app.** The `shiny` fixture starts the app a test asks for in its own R process, on a port R
   picks itself. Each app starts at most once per worker and is reused across tests; every test still gets a fresh
   browser page and therefore a fresh Shiny session.
3. **Clean shutdown.** App processes are killed when the worker finishes. If the test runner is killed hard, the R
   process notices that its parent is gone and quits within about a second (Linux and macOS, as long as the app is
   not stuck in a long R computation).

## Writing a test

```ts
import { expect, test } from '../harness';

test.use({ app: 'routing' });              // a folder under apps/ (or an absolute path)

test('a route link switches the page', async ({ page, shiny }) => {
  await shiny.goto();                      // open the app, wait until Shiny is connected and idle
  await page.locator('#link_other').click();                       // real clicks
  await expect(page).toHaveURL(/\/#!\/other$/);                     // retries until true or 5 s pass
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#current_page')).toHaveText('other'); // what the R server sees
  await shiny.expectNoErrors();            // still connected, no output errors, no JS console errors
});
```

Guidelines:

- **Open a route directly** with `shiny.goto('/#!/other')`.
- **Never sleep.** Do not use `page.waitForTimeout()`. Use `await expect(locator)...` or `expect.poll(...)`, which
  retry until the UI catches up.
- **Prefer dedicated fixture apps** in `apps/` over the demo apps in `examples/`. Keep them small and deterministic.
  `examples/` is covered by a smoke test (`specs/examples-smoke.spec.ts`) only. If an app needs a package that is
  not in `Imports`, add it to `Config/Needs/e2e` in `DESCRIPTION`; CI installs those.
- **A known bug** gets a test marked `test.fail()` with a comment. It fails loudly once the bug is fixed, as a
  reminder to remove the mark.
- `shiny.logs()` returns the R output captured since the test started, e.g. to assert that a warning was printed.

### `shiny` fixture

| Member | Purpose |
|---|---|
| `goto(path?)` | Open the app; wait until Shiny is connected and finished its first round of work. Fails immediately, with the R output, if the session dies. |
| `selectOption(inputId, value)` | Choose a value in a `selectInput` like a user would (selectize or native). |
| `inputValue(inputId)` | The value of a Shiny input as the client last sent it to the server. |
| `waitForIdle()` | Wait until Shiny is connected and not busy. Only needed in special cases; prefer assertions. |
| `logs()` | R stdout/stderr of the app since this test started. |
| `expectNoErrors()` | Wait until Shiny has been idle for 0.5 s (so outputs created by `renderUI()` have rendered), then assert there is no disconnect overlay, no visible output error, and no browser console error. |
| `app.url` | Base URL of the running app. |

## Layout

```
apps/        fixture Shiny apps (one folder each)
specs/       test files (*.spec.ts)
harness/     test infrastructure: install from source, app processes, Shiny helpers
```
