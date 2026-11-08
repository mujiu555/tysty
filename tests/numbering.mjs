import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import { stagePackage } from './package.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const output = mkdtempSync(join(tmpdir(), 'tysty-numbering-'));
const { packages } = stagePackage(root, output);
const sections = '= First\n== Detail\n= Second\n';
const cases = [
  { name: 'body', rule: '#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'cover-body', cover: true, title: 'Root', rule: '#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'embed', wrap: true, rule: '#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'middle', rule: 'Introduction.\n#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'math-outside', math: true, sections: '= First $E = m c^2$\n== Detail $alpha + beta$\n= Second\n', outer: '#show: num.with(pattern: "1.")', expected: ['2. First', '2.1. Detail', '3. Second'], title: '1. Root [root]' },
  { name: 'math-inside', math: true, sections: '= First $E = m c^2$\n== Detail $alpha + beta$\n= Second\n', rule: '#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'outside', outer: '#show: num.with(pattern: "1.")', expected: ['2. First', '2.1. Detail', '3. Second'], title: '1. Root [root]' },
  { name: 'none', outer: '#set heading(numbering: "1.")', rule: '#show: num', expected: ['First', 'Detail', 'Second'], title: '1. Root [root]' },
  { name: 'function', rule: '#show: num.with(pattern: (..values) => values.pos().map(str).join("-"))', expected: ['1 First', '1-1 Detail', '2 Second'] },
  { name: 'offset', outer: '#set heading(offset: 2)', rule: '#show: num.with(pattern: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'options', rule: '#show: num.with(pattern: "I.", outlined: false)', expected: ['I. First', 'I.I. Detail', 'II. Second'] },
  { name: 'show-set', rule: '#show heading: set heading(numbering: "1.")', expected: ['1. First', '1.1. Detail', '2. Second'] },
  { name: 'nested', rule: '#show: num.with(pattern: "1.")', extra: '#num(pattern: "a.")[\n= Nested\n= Next nested\n]\n', expected: ['1. First', '1.1. Detail', '2. Second', 'a. Nested', 'b. Next nested'] },
];
const results = [];
const clean = html => html.replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
const headings = html => [...html.matchAll(/<h[1-6]\b[^>]*>([\s\S]*?)<\/h[1-6]>/g)].map(match => clean(match[1]));
function compile(name, source, format) {
  const input = join(output, name + '.typ');
  writeFileSync(input, source);
  const target = join(output, name + '-' + format + (format === 'bundle' ? '' : format === 'svg' || format === 'png' ? '-{p}.' + format : '.' + format));
  const timings = join(output, name + '-' + format + '.trace.json');
  const args = ['compile', '--root', output, '--package-path', packages, '--features', 'html,bundle', '--format', format, '--timings', timings, input, target];
  const started = performance.now();
  const result = spawnSync('typst', args, { encoding: 'utf8', timeout: 60000 });
  const diagnostic = (result.stderr ?? '') + (result.stdout ?? '');
  assert(!result.error, `${name}/${format}: ${result.error}`);
  assert.equal(result.status, 0, `${name}/${format}: ${diagnostic}`);
  assert(!/converg|layout did not/i.test(diagnostic), `${name}/${format}: ${diagnostic}`);
  assert(readFileSync(timings, 'utf8').length > 0);
  if (format === 'pdf') assert.equal(readFileSync(target).subarray(0, 5).toString(), '%PDF-');
  if (format === 'svg' || format === 'png') {
    const pages = readdirSync(output).filter(file => file.startsWith(name + '-' + format + '-') && file.endsWith('.' + format));
    assert(pages.length > 0);
    if (format === 'png') assert.equal(readFileSync(join(output, pages[0])).subarray(1, 4).toString(), 'PNG');
    else assert(readFileSync(join(output, pages[0]), 'utf8').includes('<svg'));
  }
  results.push({ name, format, elapsedMs: Math.round(performance.now() - started), diagnostic, timings, target });
  return target;
}
for (const test of cases) {
  const source = '#import "@preview/tysty:0.1.0": *\n#show: template\n' + (test.outer ?? '') + '\n'
    + '#entry(id: "root", title: [Root], authors: (), cover: ' + (test.cover ? 'true' : 'false') + ')[\n' + (test.wrap ? '#embed[\n' : '') + (test.rule ?? '') + '\n'
    + (test.sections ?? sections) + (test.extra ?? '') + '#mkoutline()\n' + (test.wrap ? ']\n' : '') + ']\n';
  for (const format of ['pdf', 'html', 'bundle', 'svg', 'png']) {
    const target = compile(test.name, source, format);
    if (format === 'html' || format === 'bundle') {
      const html = readFileSync(format === 'html' ? target : join(target, 'index.html'), 'utf8');
      const actual = headings(html);
      assert(actual.includes(test.title ?? 'Root [root]'), `${test.name}/${format}: title ${actual}`);
      for (const expected of test.expected) assert(test.math ? actual.some(text => text.startsWith(expected)) : actual.includes(expected), `${test.name}/${format}: missing ${expected}: ${actual}`);
      if (test.name === 'body' || test.name === 'middle') assert.equal(Number(html.match(/<h([1-6])\b[^>]*>1\. First/)[1]), Number(html.match(/<h([1-6])\b[^>]*>Root /)[1]) + 1, 'Body headings must be below the document title');
      if (test.name === 'offset') assert.equal(Number(html.match(/<h([1-6])\b[^>]*>1\. First/)[1]), Number(html.match(/<h([1-6])\b[^>]*>Root /)[1]) + 1, 'num must respect inherited heading offset');
      if (test.name === 'options' && format === 'bundle') {
        const sidebar = html.match(/<aside[^>]*>([\s\S]*?)<\/aside>/)?.[1] ?? '';
        assert(!sidebar.includes('First'), 'outlined option must reach body headings');
      }
    }
  }
  console.log(`${test.name}: PDF, HTML, bundle, SVG, PNG passed`);
}
// Multiple bundle pages share counters. Reused bodies retain their num scope.
const reused = '#import "@preview/tysty:0.1.0": *\n#show: template\n'
  + '#entry(id: "root", title: [Root], authors: ())[\n#show: num.with(pattern: "1.")\n' + sections + '#mkoutline()\n]\n'
  + '#embed[\n#entry(id: "child", title: [Child], authors: ())[\n#show: num.with(pattern: "1.")\n= Child section\n#ssg.ref("root")\n]\n]\n';
const bundle = compile('reuse', reused, 'bundle');
const child = headings(readFileSync(join(bundle, 'child/index.html'), 'utf8'));
for (const expected of ['Child [child]', '3. Child section', '1. First', '1.1. Detail', '2. Second']) assert(child.includes(expected), `Reuse: missing ${expected}: ${child}`);
// Mixed bundles must select paged numbering in PDF documents and HTML in pages.
const mixed = '#import "@preview/tysty:0.1.0": *\n#show: html.bundle\n'
  + '#html.page("index.html")[#entry(id: "web", title: [Web], authors: ())[\n#show: num.with(pattern: "1.")\n' + sections + ']]\n'
  + '#document("print.pdf")[#show: template\n#entry(id: "print", parent-id: auto, title: [Print], authors: ())[\n#show: num.with(pattern: "1.")\n' + sections + ']]';
const mixedOutput = compile('mixed', mixed, 'bundle');
assert.equal(readFileSync(join(mixedOutput, 'print.pdf')).subarray(0, 5).toString(), '%PDF-');
assert(headings(readFileSync(join(mixedOutput, 'index.html'), 'utf8')).includes('1. First'));
writeFileSync(join(output, 'results.json'), JSON.stringify(results, null, 2) + '\n');
console.log(`${results.length} numbering compilations passed. Diagnostics, outputs, and timings: ${output}`);
