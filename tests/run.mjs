import { cpSync, mkdtempSync, readdirSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import assert from 'node:assert/strict';
import { stagePackage } from './package.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const output = mkdtempSync(join(tmpdir(), 'tysty-tests-'));
// Public tests use a copied preview package with manifest exclusions applied.
const { packages, destination } = stagePackage(root, output);
console.log(`Copied package: ${destination}`);
// Internal source imports also resolve to copied runtime files, with test fixtures
// supplied separately outside the package.
const testRoot = join(output, "test-project");
cpSync(join(destination, "lib"), join(testRoot, "lib"), { recursive: true });
cpSync(join(root, "tests"), join(testRoot, "tests"), { recursive: true });
const expectedErrors = JSON.parse(readFileSync(join(root, 'tests', 'reject.json'), 'utf8'));
const profile = process.argv.includes('--profile');
const filters = process.argv.slice(2).filter(arg => arg !== '--profile');
function files(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    const path = join(dir, entry.name);
    return entry.isDirectory() ? files(path) : path.endsWith('.typ') ? [path] : [];
  });
}
function formats(path) {
  if (['render/ssg.typ', 'render/ssg_ref.typ', 'render/html_bundle.typ', 'render/auto_bundle.typ'].includes(path)) return ['bundle'];
  if (['render/html_single.typ', 'render/ssg_html.typ'].includes(path)) return ['html'];
  if (['render/auto.typ', 'api/entry.typ', 'reject/render/breadcrumb_cycle.typ'].includes(path)) return ['pdf', 'html'];
  return ['pdf'];
}
let passed = 0;
let failed = 0;
function verifyOutput(path, format, destination) {
  const contains = (file, value) => assert(readFileSync(file, 'utf8').includes(value), `${file} must contain ${JSON.stringify(value)}`);
  if (path === 'api/entry.typ' && format === 'html') {
    contains(destination, 'href="https://example.com/notes/child.typ"');
  }
  if (path === 'render/ssg.typ') {
    for (const [page, css] of [['index.html', 'tysty.css'], ['research/index.html', '../tysty.css'], ['research/review/index.html', '../../tysty.css']]) {
      contains(join(destination, page), `href="${css}"`);
    }
    contains(join(destination, 'research/index.html'), 'Research questions');
    contains(join(destination, 'research/index.html'), 'class="tysty-page-outline"');
    const research = readFileSync(join(destination, 'research/index.html'), 'utf8');
    for (const page of ['index.html', 'research/index.html', 'research/review/index.html']) {
      const html = readFileSync(join(destination, page), 'utf8');
      assert(html.includes('class="tysty-page-outline"'), 'Pages must retain the right sidebar');
      assert(html.includes('class="tysty-topbar"'), 'Pages must retain the top navigation');
    }
    const sidebar = research.match(/<aside class="tysty-page-outline">([\s\S]*?)<\/aside>/)?.[1];
    const links = [...sidebar.matchAll(/<a href="#([^"]+)"[^>]*>([^<]+)<\/a>/g)];
    assert.equal(links.length, 3, 'Sidebar must include outlined body headings');
    assert(!sidebar.includes('href="../index.html#'), 'Outline must exclude headings from the root page');
    assert(!sidebar.includes('href="review/index.html#'), 'Outline must exclude headings from child pages');
    assert(!sidebar.includes('Hidden section'), 'Outline must omit headings with outlined: false');
    for (const title of ['Research questions', 'Open problems', 'Dynamic section']) {
      const entry = links.find(match => match[2].includes(title));
      assert(entry, title + ' must have a plain string link');
      assert(research.includes('id="' + entry[1] + '"'), title + ' must link to an existing heading');
    }
    contains(join(destination, 'research/index.html'), 'href="review/index.html"');
    assert(readFileSync(join(destination, 'tysty.css'), 'utf8').length > 0);
  }
  if (path === 'render/ssg_ref.typ') {
    for (const page of ['index.html', 'snippet/index.html']) contains(join(destination, page), 'SHARED-SNIPPET-BODY');
    contains(join(destination, 'index.html'), 'href="snippet/index.html"');
  }
  if (path === 'render/auto_bundle.typ') {
    contains(join(destination, 'index.html'), 'print.pdf#');
    assert(readFileSync(join(destination, 'print.pdf')).subarray(0, 5).equals(Buffer.from('%PDF-')));
  }
}
for (const input of files(join(root, 'tests')).sort()) {
  const path = relative(join(root, 'tests'), input);
  if (path.startsWith('fixtures/') || (filters.length && !filters.some(filter => path.includes(filter)))) continue;
  for (const format of formats(path)) {
    const destination = join(output, path.replaceAll('/', '-').replace(/\.typ$/, '.' + format));
    const args = ['compile', '--root', testRoot, '--package-path', packages, '--features', 'html,bundle', '--format', format, '--diagnostic-format', 'short', join(testRoot, 'tests', path), destination];
    if (profile) args.push('--timings', destination + '.trace.json');
    const started = performance.now();
    const result = spawnSync('typst', args, { cwd: root, encoding: 'utf8', timeout: 60000 });
    if (profile) console.log(path + ' (' + format + '): ' + (performance.now() - started).toFixed(1) + ' ms');
    const diagnostic = (result.stderr ?? '') + (result.stdout ?? '');
    const expected = expectedErrors[path];
    if (path.startsWith('reject/') && !expected) throw new Error(`Missing expected diagnostic: ${path}`);
    if (result.error) throw result.error;
    let ok = expected
      ? result.status !== 0 && diagnostic.includes(expected) && !diagnostic.includes('TEST FAILURE:')
      : result.status === 0 && !/converg|layout did not/i.test(diagnostic);
    let outputError;
    if (ok && !expected) {
      try { verifyOutput(path, format, destination); }
      catch (error) { ok = false; outputError = error.message; }
    }
    if (ok) {
      passed++;
    } else {
      failed++;
      console.error(`FAIL ${path} (${format})${expected ? `: expected ${JSON.stringify(expected)}` : ''}\n${outputError ?? diagnostic}`);
    }
  }
}
if (passed + failed === 0) throw new Error('No matching tests');
console.log(`${passed} passed, ${failed} failed. Outputs: ${output}`);
process.exitCode = failed ? 1 : 0;
