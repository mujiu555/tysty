import { copyFileSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join, matchesGlob } from 'node:path';
import { spawnSync } from 'node:child_process';

// Parse the manifest with the same compiler that will consume the package.
export function stagePackage(root, output) {
  copyFileSync(join(root, "typst.toml"), join(output, "typst.toml"));
  const probe = join(output, 'manifest.typ');
  writeFileSync(probe, '#metadata(toml("/typst.toml")) <manifest>\n');
  const parsed = spawnSync('typst', ['query', '--root', output, '--field', 'value', '--one', probe, '<manifest>'], { encoding: 'utf8' });
  if (parsed.status !== 0) throw new Error(parsed.stderr || String(parsed.error));
  const manifest = JSON.parse(parsed.stdout).package;
  const packages = join(output, 'packages');
  const destination = join(packages, 'preview', manifest.name, manifest.version);
  const listing = spawnSync('git', ['ls-files', '-z'], { cwd: root, encoding: 'utf8' });
  if (listing.status !== 0) throw new Error(listing.stderr);
  const rules = manifest.exclude ?? [];
  const excluded = file => rules.some(rule => {
    const anchored = rule.startsWith('/');
    const pattern = rule.replace(/^\//, '');
    const glob = pattern.endsWith('/') ? pattern + '**' : pattern;
    const candidates = anchored ? [file] : file.split('/').map((_, i, parts) => parts.slice(i).join('/'));
    return candidates.some(candidate => matchesGlob(candidate, glob));
  });
  const files = [...new Set(listing.stdout.split('\0').filter(Boolean))].filter(file => !excluded(file));
  for (const file of files) {
    const target = join(destination, file);
    mkdirSync(dirname(target), { recursive: true });
    copyFileSync(join(root, file), target);
  }
  for (const required of ['typst.toml', 'README.md', 'LICENSE', manifest.entrypoint]) {
    if (!files.includes(required)) throw new Error(`Package excludes required file: ${required}`);
  }
  // Include a manifest of the copied files to make the audit reviewable.
  writeFileSync(join(output, 'package-files.json'), JSON.stringify({ manifest, files }, null, 2) + '\n');
  return { packages, destination, manifest, files };
}
