import { expect, test } from '../harness';

test.use({ app: 'dynamic' });

test('router_ui() rendered from the server shows the root page', async ({ page, shiny }) => {
  await shiny.goto();
  await expect(page).toHaveURL(/\/#!\/$/);
  await expect(page.locator('#home_page')).toBeVisible();
  await expect(page.locator('#other_page')).toBeHidden();
  await expect(page.locator('#current_page')).toHaveText('/');
  await shiny.expectNoErrors();
});

test('route links work in router_ui() rendered from the server', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#link_other').click();
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await expect(page.locator('#current_page')).toHaveText('other');
  await shiny.expectNoErrors();
});

test('a deep link works in router_ui() rendered from the server', async ({ page, shiny }) => {
  await shiny.goto('/#!/other');
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await shiny.expectNoErrors();
});

test('a route left out on the server shows the 404 page and is not in the DOM', async ({ page, shiny }) => {
  await shiny.goto();
  await expect(page.locator('#home_page')).toBeVisible();
  await page.locator('#link_admin').click();
  await expect(page).toHaveURL(/\/#!\/404$/);
  await expect(page.getByText('No such page')).toBeVisible();
  await expect(page.locator('#admin_page')).toHaveCount(0);
  await shiny.expectNoErrors();
});

test('re-rendering router_ui() keeps the current page and adds new routes', async ({ page, shiny }) => {
  await shiny.goto('/#!/other');
  await expect(page.locator('#other_page')).toBeVisible();
  await page.getByLabel('Admin').check();
  await expect(page.locator('#admin_page')).toHaveCount(1);
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#admin_page')).toBeHidden();
  await page.locator('#link_admin').click();
  await expect(page).toHaveURL(/\/#!\/admin$/);
  await expect(page.locator('#admin_page')).toBeVisible();
  await shiny.expectNoErrors();
});

test('re-rendering router_ui() with the same routes keeps the current page', async ({ page, shiny }) => {
  await shiny.goto('/#!/other');
  await expect(page.locator('#other_page')).toBeVisible();
  await page.locator('#other_page').evaluate((el) => el.setAttribute('data-old', 'true'));
  await page.locator('#rerender').click();
  // The page was replaced by the re-render, and the new one is shown.
  await expect(page.locator('#other_page:not([data-old])')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await shiny.expectNoErrors();
});
