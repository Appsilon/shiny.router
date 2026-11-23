import { expect, test } from '@appsilon/shiny-playwright';

// The router lives in a module with the id "nav", so its elements and outputs have the "nav-" prefix.
test.use({ app: 'module' });

test('opens the named root page', async ({ page, shiny }) => {
  await shiny.goto();
  await expect(page).toHaveURL(/\/#!\/home$/);
  await expect(page.locator('#nav-home_page')).toBeVisible();
  await expect(page.locator('#nav-other_page')).toBeHidden();
  await expect(page.locator('#nav-current_page')).toHaveText('home');
  await shiny.expectNoErrors();
});

test('links switch pages and the module server sees the page', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#nav-link_other').click();
  await expect(page).toHaveURL(/\/#!\/other$/);
  await expect(page.locator('#nav-other_page')).toBeVisible();
  await expect(page.locator('#nav-home_page')).toBeHidden();
  await expect(page.locator('#nav-current_page')).toHaveText('other');
  await expect(page.locator('#nav-other_text')).toHaveText('Rendered for the other page');

  await page.locator('#nav-link_home').click();
  await expect(page.locator('#nav-home_page')).toBeVisible();
  await expect(page.locator('#nav-current_page')).toHaveText('home');
  await shiny.expectNoErrors();
});

test('an unknown route shows the default 404 page', async ({ page, shiny }) => {
  // Paths are checked against the module's namespaced "routes" input.
  await shiny.goto('/#!/missing');
  await expect(page).toHaveURL(/\/#!\/404$/);
  await expect(page.getByRole('heading', { name: 'Not found' })).toBeVisible();
  await expect(page.locator('#nav-home_page')).toBeHidden();
  await shiny.expectNoErrors();
});
