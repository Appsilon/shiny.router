# End-to-end tests

Browser tests for shiny.router, written with [Playwright](https://playwright.dev). They start real Shiny
apps that use the package **built from this checkout** and drive them in Chromium.

The fixtures, the config and the CI workflow come from the shared package
[`@appsilon/shiny-playwright`](https://github.com/Appsilon/shiny.playwright). Its
[README](https://github.com/Appsilon/shiny.playwright#readme) documents the `shiny` fixture, the options, how
apps are started, and how to write a test.

This folder is excluded from the package build (`.Rbuildignore`), so `R CMD check` and CRAN never see it.

## Running

Prerequisites: R with the package's dependencies installed plus the packages in `Config/Needs/e2e` in
`DESCRIPTION` (`pak::local_install_deps(dependencies = "Config/Needs/e2e")`), and Node.js 20 or newer.

```sh
cd tests/e2e
npm ci                               # first time, or after package-lock.json changes
npx playwright install chromium      # first time, or after upgrading @playwright/test
npm test                             # run everything
CI=1 npm test                        # run as CI does, in your Google Chrome
```

To run against another Shiny version, install it into a separate library and put that library on `R_LIBS`, e.g.
`R_LIBS=/path/to/shiny-1.7.5.1-lib npm test`.

`.github/workflows/e2e.yml` calls the package's reusable workflow, which runs the tests with Shiny 1.7.5.1 and
with the latest release. If tests fail, download the `e2e-shiny-<version>` artifact: it holds the HTML report
and, per failed test, the trace and `app.log`.

## Layout

```
apps/        fixture Shiny apps (one folder each); prefer these over the demo apps in examples/
specs/       test files (*.spec.ts); examples-smoke.spec.ts starts every app in examples/
```
