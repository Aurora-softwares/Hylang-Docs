// @ts-check

const lightCodeTheme = require('prism-react-renderer').themes.github;
const darkCodeTheme = require('prism-react-renderer').themes.dracula;

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Hylang',
  tagline: 'A self-hosted systems language for Australis OS and its native applications.',
  favicon: 'img/hylang-mark.svg',

  url: 'https://aurora-softwares.github.io',
  baseUrl: '/Hylang-Docs/',

  organizationName: 'Aurora-Softwares',
  projectName: 'Hylang-Docs',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: 'docs',
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/Aurora-Softwares/Hylang-Docs/edit/main/',
          showLastUpdateAuthor: false,
          showLastUpdateTime: false,
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/hylang-mark.svg',
      metadata: [
        {
          name: 'description',
          content: 'Documentation for Hydrogen, the self-hosted language for Australis OS and its native applications.',
        },
      ],
      navbar: {
        title: 'Hylang',
        logo: {
          alt: 'Hylang mark',
          src: 'img/hylang-mark.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'docs',
            position: 'left',
            label: 'Docs',
          },
          {
            href: 'https://github.com/Aurora-Softwares/Hylang-Compiler',
            label: 'Compiler',
            position: 'right',
          },
          {
            href: 'https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose',
            label: 'Request a feature',
            position: 'right',
          },
          {
            href: 'https://github.com/Aurora-Softwares/Hylang-Docs',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Getting Started',
                to: '/getting-started/installing',
              },
              {
                label: 'Language Guide',
                to: '/language/structure',
              },
              {
                label: 'Runtime',
                to: '/runtime/runtime-model',
              },
            ],
          },
          {
            title: 'Project',
            items: [
              {
                label: 'Hylang Compiler',
                href: 'https://github.com/Aurora-Softwares/Hylang-Compiler',
              },
              {
                label: 'Australis OS',
                href: 'https://aurora-softwares.github.io/Australis-Docs/',
              },
              {
                label: 'Request a feature',
                href: 'https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Aurora Softwares.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
      colorMode: {
        defaultMode: 'dark',
        respectPrefersColorScheme: true,
      },
    }),
};

module.exports = config;
