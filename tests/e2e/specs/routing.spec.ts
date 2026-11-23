import { expect, test } from '@appsilon/shiny-playwright';

test.use({ app: 'routing' });

test('opens the root page on load and adds #!/ to the URL', async ({ page, shiny }) => {
  await shiny.goto();
  await expect(page).toHaveURL(/\/#!\/$/);
  await expect(page.locator('#home_page')).toBeVisible();
  await expect(page.locator('#other_page')).toBeHidden();
  await expect(page.getByText('No such page')).toBeHidden();
  await expect(page.locator('#current_page')).toHaveText('/');
  await shiny.expectNoErrors();
});

test('a route link switches the page', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#link_other').click();
  await expect(page).toHaveURL(/\/#!\/other$/);
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  // What the server sees.
  await expect(page.locator('#current_page')).toHaveText('other');
  await expect(page.locator('#on_other')).toHaveText('TRUE');
  await shiny.expectNoErrors();
});

test('a deep link opens that page', async ({ page, shiny }) => {
  await shiny.goto('/#!/other');
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await expect(page.locator('#current_page')).toHaveText('other');
  await shiny.expectNoErrors();
});

test('an unknown route shows the 404 page', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#link_missing').click();
  await expect(page).toHaveURL(/\/#!\/404$/);
  await expect(page.getByText('No such page')).toBeVisible();
  await expect(page.locator('#home_page')).toBeHidden();
  await expect(page.locator('#other_page')).toBeHidden();
  await shiny.expectNoErrors();
});

test('browser back and forward move between pages', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#link_other').click();
  await expect(page.locator('#other_page')).toBeVisible();

  await page.goBack();
  await expect(page).toHaveURL(/\/#!\/$/);
  await expect(page.locator('#home_page')).toBeVisible();
  await expect(page.locator('#other_page')).toBeHidden();
  await expect(page.locator('#current_page')).toHaveText('/');

  await page.goForward();
  await expect(page).toHaveURL(/\/#!\/other$/);
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#current_page')).toHaveText('other');
  await shiny.expectNoErrors();
});

test('change_page() on the server navigates and passes the query', async ({ page, shiny }) => {
  await shiny.goto();
  await page.locator('#go_other').click();
  await expect(page).toHaveURL(/\/#!\/other\?id=42&tab=b$/);
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#current_page')).toHaveText('other');
  await expect(page.locator('#query')).toHaveText('id=42&tab=b');
  await shiny.expectNoErrors();
});

test('query parameters in a deep link reach the server', async ({ page, shiny }) => {
  await shiny.goto('/#!/other?id=7');
  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#query')).toHaveText('id=7');
  await shiny.expectNoErrors();
});

test('a hash without the #! prefix is rewritten and opens that page', async ({ page, shiny }) => {
  await shiny.goto('/#other');
  await expect(page).toHaveURL(/\/#!\/other$/);
  await shiny.expectNoErrors();

  await expect(page.locator('#other_page')).toBeVisible();
  await expect(page.locator('#current_page')).toHaveText('other');
});
