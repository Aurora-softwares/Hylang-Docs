# Hydrogen documentation site

This is the Astro Starlight documentation site for Hydrogen/Hylang. It is
independent from the legacy Docusaurus tree and is the site to deploy for the
release-first Hydrogen documentation.

## Local development

```bash
npm install
npm run dev
```

Build the static site with:

```bash
npm run build
```

The deployable output is `dist/`.

## Cloudflare Pages

Create a Cloudflare Pages project connected to this repository and use:

| Setting | Value |
| --- | --- |
| Root directory | Repository root (leave blank) |
| Build command | `npm run build` |
| Build output directory | `dist` |
| Node.js version | 20 or newer |

After adding the custom domain in Cloudflare Pages, set the project environment
variable `SITE_URL` to its complete public origin, for example:

```text
https://docs.example.com
```

Astro uses that value when generating absolute sitemap and canonical URLs. Do not
include a trailing slash.

## Content

Documentation pages live in `src/content/docs/`; navigation and site identity are
configured in `astro.config.mjs`. The current site documents the released,
self-hosted Hydrogen compiler, the UEFI Hello World proof, and the Australis-first
roadmap.
