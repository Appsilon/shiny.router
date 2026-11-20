import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  globalSetup: './harness/global-setup.ts',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  // No retries during the PoC: a flaky test should fail loudly, not pass on a retry.
  retries: 0,
  reporter: [['list'], ['html', { open: 'never' }]],
  use: {
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        // In CI, use the Google Chrome that comes with the GitHub runner image. Playwright's own Chromium
        // needs system packages from the Ubuntu mirror (`--with-deps`), which is slow and sometimes fails.
        channel: process.env.CI ? 'chrome' : undefined,
      },
    },
  ],
});
