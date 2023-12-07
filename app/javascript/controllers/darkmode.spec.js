import { render, startStimulus, screen, userEvent } from '../jest/utils';
import Darkmode from './darkmode';

const user = userEvent.setup();

const html = `
<div data-controller="darkmode" class="flex items-center justify-between">
  <h2 data-darkmode-target="description" data-action="click->darkmode#toggle" class="hidden mr-3 sm:block cursor-pointer">Light Mode</h2>
  <button data-action="click->darkmode#toggle" id="theme-toggle" type="button" class="text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5" aria-label="Toggle Dark Mode" role="button">
    <svg aria-role="graphics-symbol" data-darkmode-target="darkIcon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
    <svg aria-role="graphics-symbol" data-darkmode-target="lightIcon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
  </button>
</div>
`;

describe('Darkmode', () => {
  beforeEach(() => {
    startStimulus('darkmode', Darkmode);
  });

  afterEach(() => {
    document.documentElement.classList.remove('light');
    document.documentElement.classList.remove('dark');
    localStorage.removeItem('color-theme');
  });

  it('should initialize in light mode', async () => {
    await render(html);

    const heading = await screen.findByRole('heading');

    expect(heading).toHaveTextContent('Light Mode');
    expect(document.documentElement).not.toHaveClass('dark');
  });

  it('should initialize in dark mode', async () => {
    localStorage.setItem('color-theme', 'dark');

    await render(html);

    const heading = await screen.findByRole('heading');

    expect(heading).toHaveTextContent('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
  });

  it('should set to dark mode', async () => {
    await render(html);

    const button = await screen.findByRole('button');
    await user.click(button);

    await screen.findByText('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');
  });

  it('should set to light mode', async () => {
    await render(html);

    const button = screen.getByRole('button');
    await user.click(button);

    await screen.findByText('Dark Mode');
    expect(document.documentElement).toHaveClass('dark');

    await user.click(button);
    await screen.findByText('Light Mode');
    expect(document.documentElement).not.toHaveClass('dark');
  });
});