<div align="center">

<img src="assets/hydrogen.icon.svg" width="30%" />

# Hydrogen documentation site

</div>

This is Hydrogen's Astro website. A Haze-inspired pastel welcome page lives at `/`, while Astro Starlight provides searchable documentation at `/docs/` and retains the existing reference URLs. There are also guides at `/guides/` and downloadable starter code at `/samples/`.

## Local development

```bash
npm install
npm run dev
```

Build the static site with:

```bash
npm run build
```

The deployable output is `dist/`. The static assets in `public/` include
`install.sh`, `install.ps1`, and the curated source registry at
`registry/v1/`. Rebuild registry assets with `python3 tools/build-registry.py`
after changing `registry/approved.json`; check them with
`python3 tools/build-registry.py --check`.

## Cloudflare Pages

Create a Cloudflare Pages project connected to this repository and use:

| Setting | Value |
| --- | --- |
| Root directory | Repository root (leave blank) |
| Build command | `npm run build` |
| Build output directory | `dist` |
| Node.js version | 22 or newer |
| Production branch | `Release` |

In Cloudflare Pages, enable **automatic production branch deployments** for the `Release` branch under **Settings → Builds & deployments → Branch control**. The GitHub Actions `site-ci.yml` workflow only verifies the site; it does **not** publish to Cloudflare. Cloudflare's own Git integration handles deployment on a push to `Release`. Do not use `Development` as production unless you intentionally want preview changes publicly visible.

After adding the custom domain in Cloudflare Pages, set the project environment
variable `SITE_URL` to its complete public origin, for example:

```text
https://hylang.co.uk
```

Astro uses that value when generating absolute sitemap and canonical URLs. Do not
include a trailing slash.

## Content

The home page lives in `src/pages/index.astro`; starter source files live in `public/samples/`. Documentation pages live in `src/content/docs/`; navigation and site identity are
configured in `astro.config.mjs`. The current site documents Hydrogen
`alpha-0.0.2`, including its self-hosted compiler, Linux-native language surface,
UEFI bootloader and early-kernel profiles. It also describes newer Australis
project and application features in the development compiler checkout, clearly
separated from the published release. The current Australis checkout adds
raw-kernel/AUEX project support; its small AUN1 ring-3 loader is an OS feature,
not yet a Hydrogen source compilation target.
