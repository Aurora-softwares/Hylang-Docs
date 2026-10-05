# Hylang documentation

This repository builds the Hydrogen language and tool reference with Docusaurus. The published guide is at [Hylang-Docs](https://aurora-softwares.github.io/Hylang-Docs/).

## Preview and build

Use Node.js 20 or newer and npm:

```bash
npm ci
npm start
```

For a production build and local preview:

```bash
npm run build
npm run serve
```

Docs live under `docs/`; `sidebars.js` defines navigation. The home page is `docs/README.md`. Existing implementation-page IDs are retained for links, while their content describes architecture rather than phase progress.

## Editing

Document executable syntax and commands against the compiler implementation and tests. Distinguish the native Hydrogen compiler from the broader C++ SDK; mark route-specific language and APIs explicitly. Prefer complete runnable tutorial examples, and identify context for reference fragments. Project-relative paths in CLI examples assume the compiler checkout, not this documentation repository.

Future proposals belong in the roadmap or design plans. Run `npm run build` to verify MDX and internal links after changes.
