// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
    site: process.env.SITE_URL,
    integrations: [starlight({
        title: 'Hydrogen',
		logo: {
			src: './assets/hydrogen.icon.svg',
		},
        description: 'The self-hosted language for Australis OS and its native applications.',
        social: [
			{
				icon: 'github',
				label: 'Hydrogen Compiler on GitHub',
				href: 'https://github.com/Aurora-Softwares/Hylang-Compiler'
			}
		],
        editLink: {
            baseUrl: 'https://github.com/Aurora-Softwares/Hylang-Docs/edit/main/',
        },
        customCss: [
			'./src/styles/custom.css'
		],
        head: [
            {
                tag: 'meta',
                attrs: {
                    name: 'theme-color',
                    content: '#5b5bd6',
                },
            },
        ],
        sidebar: [
            {
                label: 'Getting Started',
                items: [
                    { label: 'Install the released compiler', slug: 'getting-started/installing' },
                    { label: 'Current release', slug: 'getting-started/current-release' },
                    { label: 'Write and run a program', slug: 'getting-started/running' },
                    { label: 'Build with Hydrogen', slug: 'getting-started/building' },
                    { label: 'Compile an executable', slug: 'getting-started/compiling' },
                    { label: 'Make a bootable UEFI Hello World', slug: 'getting-started/uefi-hello' },
                ],
            },
            {
                label: 'Language Guide',
                items: [
                    { label: 'Program structure', slug: 'language/structure' },
                    { label: 'Methods and objects', slug: 'language/methods-and-objects' },
                    { label: 'Types and strings', slug: 'language/types' },
                    { label: 'Arrays', slug: 'language/arrays-and-collections' },
                    { label: 'Operators', slug: 'language/operators' },
                    { label: 'Control flow', slug: 'language/control-flow' },
                    { label: 'Enums', slug: 'language/enums' },
                    { label: 'Access modifiers', slug: 'language/access-modifiers' },
                ],
            },
            {
                label: 'Tools and Runtime',
                items: [
                    { label: 'Hydrogen compiler', slug: 'tools/hydrogen' },
                    { label: 'Projects and references', slug: 'tools/projects' },
                    { label: 'Builtin APIs', slug: 'runtime/builtins' },
                    { label: 'Runtime behavior', slug: 'runtime/runtime-model' },
                ],
            },
            {
                label: 'Contributors',
                collapsed: true,
                items: [
                    { label: 'Self-hosting preparation', slug: 'implementation/phase5-self-hosting-prep' },
                    { label: 'Self-hosted compiler', slug: 'implementation/phase6-self-hosted-compiler' },
                ],
            },
            {
				label: 'Roadmap',
				slug: 'roadmap'
			},

		],
	})],
});
