import assert from 'node:assert/strict';
import { existsSync, mkdtempSync, readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import { stagePackage } from './package.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const output = mkdtempSync(join(tmpdir(), 'tysty-docs-'));
const { packages, destination, files } = stagePackage(root, output);
console.log(`Copied package: ${destination}`);
assert(!files.some(file => file.startsWith('doc/') || file.startsWith('tests/')));
let passed = 0;
for (const file of ['README.md', 'doc/README.api.en.md', 'doc/README.api.zh_cn.md']) {
  const markdown = readFileSync(join(root, file), 'utf8');
  for (const match of markdown.matchAll(/!?\[[^\]]*\]\(([^)]+)\)/g)) {
    const target = match[1];
    if (/^(https?:|#)/.test(target)) continue;
    assert(existsSync(resolve(root, dirname(file), decodeURIComponent(target.split('#')[0]))), `${file}: missing ${target}`);
  }
  for (const [index, block] of [...markdown.matchAll(/```typst\n([\s\S]*?)```/g)].entries()) {
    let source = block[1];
    if (!source.includes('#import')) source = '#import "@preview/tysty:0.1.0": *\n#show: template\n' + source;
    assert(!source.includes('@local/'), `${file}: example uses local namespace`);
    const bundle = source.includes('#show: html.bundle') || source.includes('--format bundle');
    const formats = bundle ? ['bundle'] : source.includes('#entry(') ? ['pdf', 'html'] : ['pdf'];
    const input = join(output, `${file.replaceAll('/', '-')}-${index}.typ`);
    writeFileSync(input, source);
    for (const format of formats) {
      const target = input + '.' + format;
      const result = spawnSync('typst', ['compile', '--root', output, '--package-path', packages, '--features', 'html,bundle', '--format', format, input, target], { encoding: 'utf8', timeout: 60000 });
      assert.equal(result.status, 0, `${file} example ${index} (${format}): ${result.stderr || result.error}`);
      if (format === 'pdf') assert.equal(readFileSync(target).subarray(0, 5).toString(), '%PDF-');
      if (format === 'html') assert(readFileSync(target, 'utf8').includes('<html'));
      if (bundle) {
        const pages = [];
        function inspect(dir) {
          for (const name of readdirSync(dir)) {
            const path = join(dir, name);
            if (statSync(path).isDirectory()) inspect(path);
            else if (name.endsWith('.html')) {
              pages.push(path);
              const html = readFileSync(path, 'utf8');
              for (const css of html.matchAll(/href="([^"#]+\.css)"/g)) assert(existsSync(resolve(dirname(path), css[1])), `${path}: missing stylesheet`);
            }
          }
        }
        inspect(target);
        assert(pages.length > 0, 'Bundle must contain HTML pages');
        if (file === 'README.md') {
          for (const route of ['index.html', 'research/index.html', 'research/review/index.html', 'tysty.css']) assert(existsSync(join(target, route)), `Missing ${route}`);
          assert(readFileSync(join(target, 'research/review/index.html'), 'utf8').includes('Research questions'));
        }
      }
      passed++;
    }
  }
}
console.log(`${passed} documentation compilations passed; links, PDF/HTML signatures, bundle routes, CSS, and reused content checked. Outputs: ${output}`);
