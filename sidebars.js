// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  docs: [
    'README',
    {
      type: 'category',
      label: 'Getting Started',
      collapsed: false,
      items: [
        'getting-started/installing',
        {
          type: 'doc',
          id: 'getting-started/compiler-options',
          label: 'Current release',
        },
        'getting-started/running',
        'getting-started/building',
        'getting-started/compiling',
        'getting-started/uefi-hello',
      ],
    },
    {
      type: 'category',
      label: 'Language Guide',
      collapsed: false,
      items: [
        'language/structure',
        'language/methods-and-objects',
        'language/types',
        'language/arrays-and-collections',
        'language/operators',
        'language/control-flow',
        'language/enums',
        'language/access-modifiers',
      ],
    },
    {
      type: 'category',
      label: 'Tools',
      collapsed: false,
      items: ['tools/hydrogen', 'tools/projects'],
    },
    {
      type: 'category',
      label: 'Runtime',
      collapsed: false,
      items: ['runtime/builtins', 'runtime/runtime-model'],
    },
    {
      type: 'category',
      label: 'Compiler Architecture',
      collapsed: true,
      items: [
        'implementation/phase5-self-hosting-prep',
        'implementation/phase6-self-hosted-compiler',
      ],
    },
    'roadmap',
  ],
};

module.exports = sidebars;
