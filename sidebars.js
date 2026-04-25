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
        'getting-started/building',
        'getting-started/running',
        'getting-started/compiling',
      ],
    },
    {
      type: 'category',
      label: 'Language Guide',
      collapsed: false,
      items: [
        'language/structure',
        'language/types',
        'language/arrays-and-collections',
        'language/operators',
        'language/control-flow',
        'language/enums',
        'language/inheritance',
        'language/interfaces-and-structs',
        'language/generics',
        'language/overloading',
        'language/access-modifiers',
      ],
    },
    {
      type: 'category',
      label: 'Tools',
      collapsed: false,
      items: ['tools/hy', 'tools/hyrun', 'tools/hyc'],
    },
    {
      type: 'category',
      label: 'Runtime',
      collapsed: false,
      items: ['runtime/runtime-model', 'runtime/unsafe-design'],
    },
    {
      type: 'category',
      label: 'Implementation Notes',
      collapsed: false,
      items: [
        'implementation/phase2-bootstrap-spec',
        'implementation/phase4-tooling-slice',
        'implementation/phase5-self-hosting-prep',
        'implementation/phase6-self-hosted-compiler',
      ],
    },
    'roadmap',
  ],
};

module.exports = sidebars;
