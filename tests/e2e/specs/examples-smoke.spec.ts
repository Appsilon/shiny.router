import { expect, test } from '@appsilon/shiny-playwright';

// Every Shiny example in examples/ must start, show its root page ("Home page" in all of them) and render without
// errors.
// shiny_semantic and remember_page_state.R need shiny.semantic (Config/Needs/e2e in DESCRIPTION).
const EXAMPLES = [
  'basic/app.R',
  'basic_dynamic_dots/app.R',
  'get_params.R',
  'remember_page_state.R',
  'shiny_modules/app.R',
  'shiny_semantic/app.R',
  'tutorial.R',
];

for (const example of EXAMPLES) {
  test.describe(`examples/${example}`, () => {
    test.use({ app: `examples/${example}` });

    test('starts and shows the root page without errors', async ({ page, shiny }) => {
      await shiny.goto();
      await expect(page.getByRole('heading', { name: 'Home page', exact: true })).toBeVisible();
      await shiny.expectNoErrors();
    });
  });
}
