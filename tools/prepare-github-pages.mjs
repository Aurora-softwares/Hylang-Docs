/**
 * Fix root-relative links rendered by Starlight Markdown/MDX and our standalone
 * Astro welcome page when the site is hosted on a GitHub Pages project subpath.
 *
 * Astro prefixes its own assets and sidebar links using `base`, but links authored
 * as "/docs/" or "/samples/hello.hy" remain root-relative by design. Do not
 * change source documentation: this output-only step is used for GitHub Pages.
 */
import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

const rawBase = process.env.SITE_BASE;
if (!rawBase || !/^\/[A-Za-z\d._~/-]+\/?$/.test(rawBase) || rawBase === '/') {
  throw new Error('SITE_BASE must be a repository subpath, e.g. /Hylang-Docs');
}
const base = rawBase.replace(/\/+$/, '');
const baseSegment = base.slice(1);
const output = resolve('dist');
if (!existsSync(join(output, 'index.html'))) {
  throw new Error('Missing dist/index.html. Run astro build before this script.');
}

const prefix = (url) => url === base || url.startsWith(base + '/') ? url : base + url;
const linkAttr = /\b(href|src|poster|action)=(["'])(\/(?!\/)[^"']*)\2/g;
const srcsetAttr = /\bsrcset=(["'])(.*?)\1/g;
let pages = 0, updated = 0;
function walk(dir) {
  for (const entry of readdirSync(dir)) {
    const file = join(dir, entry);
    if (statSync(file).isDirectory()) {
      walk(file);
      continue;
    }
    if (!file.endsWith('.html')) continue;
    let source = readFileSync(file, 'utf8');
    source = source.replace(linkAttr, (match, attr, quote, url) => {
      const next = prefix(url);
      if (next !== url) updated++;
      return attr + '=' + quote + next + quote;
    });
    source = source.replace(srcsetAttr, (match, quote, urls) => {
      const next = urls.replace(/(^|,\s*)(\/(?!\/)[^\s,]+)/g, (part, delimiter, url) => {
        const converted = prefix(url);
        if (converted !== url) updated++;
        return delimiter + converted;
      });
      return 'srcset=' + quote + next + quote;
    });
    writeFileSync(file, source);
    pages++;
    for (const match of source.matchAll(linkAttr)) {
      const url = match[3];
      if (url !== base && !url.startsWith(base + '/')) {
        throw new Error('Unprefixed internal URL in ' + file + ': ' + url);
      }
    }
  }
}
walk(output);

for (const page of ['index.html', 'docs/index.html', 'guides/index.html', 'samples/index.html', 'guides/first-project/index.html']) {
  if (!existsSync(join(output, page))) throw new Error('Missing expected page: ' + page);
}
for (const sample of ['hello.hy', 'count-to-five.hy', 'greet-you.hy']) {
  if (!existsSync(join(output, 'samples', sample))) throw new Error('Missing starter download: ' + sample);
}
console.log('Prepared ' + pages + ' HTML pages under /' + baseSegment + '/ (' + updated + ' URLs updated).');
