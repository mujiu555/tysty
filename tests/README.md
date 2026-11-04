# Tests

Use Node.js 24 or later and Typst 0.15.1 or later.

```sh
node tests/run.mjs
node tests/docs.mjs
node tests/numbering.mjs
```

All three commands copy tracked project files into a temporary
`packages/preview/tysty/0.1.0` directory, applying the manifest's `exclude`
patterns. The copy includes current working-tree edits to tracked files.
New package files must be tracked before they enter the copy. No package is
symlinked, and installed packages are not modified. Each run prints its package
and output paths; `package-files.json` records the manifest and copied files.

## Public and internal tests

The public API is the set of names selected in `lib/_lib.typ/tysty.typ`.
`api/exports.typ` imports those names from `@preview/tysty:0.1.0`.
`api/entry.typ` exercises public document creation as PDF and HTML, including
references, child lists, metadata, and source links.

Tests using only public APIs import the copied preview package. Tests requiring
internal APIs import `/lib/_lib.typ/lib.typ` explicitly for the common APIs and
import the implementation module for the internal function being exercised.
For example, `documents` comes from `/lib/_lib.typ/doc.typ` and automatic
`mkdoc` comes from `/lib/_lib.typ/render.typ`. These internal tests resolve source imports against a separate test project
containing the copied package's runtime files and the test fixtures. Their
imports do not enlarge the public package contract.

Internal coverage includes:

- Metadata queries in `art/*` and `api/types_tags.typ`.
- Automatic `mkdoc` in `render/auto.typ`, `render/auto_bundle.typ`, and the
  breadcrumb-cycle rejection cases.
- Function identity in `render/aliases.typ`.
- UID, records, enums, state, utilities, decorators, and their rejection cases.

The exported `pdf`, `html`, and `ssg` namespaces are tested through the preview
package in their corresponding rendering tests. SSG assertions inspect routes,
CSS links, section outlines, reused page bodies, and mixed HTML/PDF bundles.

Rejection cases must fail with the specific diagnostic in `reject.json`.
An unrelated error does not count as a pass. Fixtures are helper files.

## Selecting tests

Pass path fragments to select cases:

```sh
node tests/run.mjs api render
node tests/run.mjs uid
```

PDF, HTML, and bundle cases use their respective output targets. `render/auto`
and `api/entry` run as PDF and HTML. Outputs remain in the reported temporary
directory for inspection.

## Documentation checks

`node tests/docs.mjs` extracts all Typst code blocks from the project README, the English and Chinese
publication READMEs, and both API references. Complete examples compile as written against the copied preview
package. Snippets receive the package import and template setup. The command
checks local documentation links, PDF/HTML output, generated bundle routes,
stylesheet paths, and reused research-page content. Documentation remains in
the checkout for extraction; it is excluded from the copied runtime package.

## Performance profiling

```sh
node tests/run.mjs --profile art api render
```

Each compilation prints elapsed wall time and writes a `*.trace.json` beside
its output using Typst's `--timings` option. Open traces in
[Perfetto](https://ui.perfetto.dev). Profiling runs the normal output checks too.

Compare the same compiler, machine, fonts, fixtures, targets, and job count.
Warm up once, then compare medians and ranges from at least five independent
runs without competing builds. Trace collection adds overhead; use ordinary
compilations for headline timings. Record the compiler version, revision,
commands, and environment with results.

## Numbering checks

`node tests/numbering.mjs` compiles numbering cases as PDF, HTML, bundle, SVG,
and PNG. It checks rules at the start and middle of an entry body (including a cover entry), an outer
rule, disabled numbering, function patterns, inherited offsets, heading
options, nested scopes, a heading show-set rule, reused page bodies, and mixed
HTML/PDF bundles. Number text and heading ranks are inspected in HTML; output
files and compiler diagnostics are checked for every target. Layout convergence
warnings fail the run. Each compilation writes a timing trace; `results.json`
records output paths, timings, and diagnostics in the reported temporary folder.
