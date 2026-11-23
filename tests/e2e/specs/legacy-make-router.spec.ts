import { expect, test } from '@appsilon/shiny-playwright';

test.use({ app: 'legacy_make_router' });

test('opens the root page on load', async ({ page, shiny }) => {
  await shiny.goto();
  await expect(page).toHaveURL(/\/#!\/$/);
  await expect(page.locator('#home_page')).toBeVisible();
  await expect(page.locator('#other_page')).toBeHidden();
  await shiny.expectNoErrors();
});

test("a deep link opens the page and the route's server function runs", async ({ page, shiny }) => {
  await shiny.goto('/#!/other');
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await expect(page.locator('#other_text')).toHaveText("Rendered by the route's server");
  await shiny.expectNoErrors();
});

test('an unknown route shows the default 404 page', async ({ page, shiny }) => {
  await shiny.goto('/#!/missing');
  await expect(page).toHaveURL(/\/#!\/404$/);
  await expect(page.getByRole('heading', { name: 'Not found' })).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await shiny.expectNoErrors();
});
