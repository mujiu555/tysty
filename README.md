# Tysty

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![conventional commit compliant](https://img.shields.io/badge/git%20commit-conventional%20commit-brightgreen.svg?style=flat-square)](https://www.conventionalcommits.org/en/v1.0.0/#specification)
[![git flow compliant](https://img.shields.io/badge/branch-git%20flow-brightgreen.svg?style=flat-square)](./doc/README.gitflow.md)

## Background

### Referencing

### Credit: Code/Library

## Structure

The whole project is organized in following structure:

```txt
Root: /                         ; Project root
+- .git/                        ; git repository
+- doc/                         ; documentation & copyright information
|  +- licenses/                 ; licenses and notice form other libraries
|  +- LICENSE                   ; copy of the LICENSE
|  +- LICENSE.apache            ; copy of the original LICENSE
|  +- README                    ; README for directory `doc`
|  +- README.commit.md          ; git commit convention
|  +- README.gitflow.md         ; git flow convention
|  +- README.release.md         ; semantic versioning 
+- lib/                         ; libraries
|  +- _lib.typ/                 ; source code
+- .gitignore
+- .gitmodules
+- LICENSE
+- README.md
+- typst.toml                   ; library spec
```

## Usage

API reference: [English](doc/README.api.en.md) · [简体中文](doc/README.api.zh_cn.md)

```typst
// Save this example as notebook.typ.
// Compile with: typst compile --root . notebook.typ
// Requires tysty 0.1.0 installed in the local package namespace.
#import "@local/tysty:0.1.0": *
// Top-level APIs automatically select PDF or HTML at the call site.
// Explicit pdf.* and html.* APIs remain available.
// Export this source as HTML with: typst compile --features html notebook.typ notebook.html
#show: template

// set file base, if you do not set this path,
// you must have to set file_path argument manually
#set-base("file:///path/to/project/")

// Register a namespace and its nested tags.
#let topics = (tag.register)("notebook", (
  science: (physics: (:),),
))
#let physics = topics.children.science.children.physics.tag
// Attach a tag to a document by adding tags: (physics,) to its entry call.

// Declare and render a document with entry.
// Place cover rendering inside its content.
// id, title, and authors are required; authors is an array of names or author records.
// Each document id must be unique within one compilation.
// Omitting parent_id inherits the current document, if one exists.
// Use parent_id: auto to declare an independent root.
#entry(
  id: "notebook",
  title: [Book],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30),
  tags: (physics,),
)[
  #mkcover()
  // Automatic outline: headings in PDF/single HTML, document routes in bundles.
  #mkoutline()
]

// entry renders a heading and body, registers the document as a reference
// target, and adds it to the prev/next reading sequence.
#entry(
  id: "note 1",
  parent_id: auto,
  title: [Note 1],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30),
)[
  // embed increases the heading offset and restores the outer document context.
  // For a separate source file, use #embed(include "child.typ").
  // Semantic parent relationships are declared explicitly with parent_id.
  #embed[
    #entry(
      id: "sub note 1",
      parent_id: "note 1",
      title: [Sub Note 1],
      authors: ("Alice",),
      // due to typst time limitation
      date: datetime(year: 2026, month: 10, day: 30, hour: 23, minute: 46, second: 0),
    )[
      sub note 1 content
    ]
  ]
  #entry(
    id: "sub note 2",
    parent_id: "note 1",
    title: [Sub Note 2],
    authors: ("Alice",),
    date: datetime(year: 2026, month: 10, day: 30, hour: 23, minute: 46, second: 0),
  )[
    sub note 2 content
    #mkindex("label")[content shown]
  ]

  #render-children[Children]
  // This will display all sub notes associated with it
]

// A semantic child can also appear outside an embedded body.
#entry(
  id: "sub note 3",
  parent_id: "note 1",
  title: [Sub Note 3],
  authors: ("Alice",),
  date: datetime(year: 2026, month: 10, day: 30, hour: 23, minute: 46, second: 0),
)[
  #mkcover()
  sub note 3 content
  #lookup("label")[reference]
]

#let alice = (author.new)(
  name: "Alice",
  home: "home rl",
  email: "no.reply@github.com",
  affiliation: "",
  orcid: "",
)

#let topics2 = (tag.register)(
  // register tag namespace
  "topics:root",
  (
  // two sub tag
    index: (:),
    about: (:),
  ),
)

#let index = topics2.children.index.tag
#let about = topics2.children.about.tag

#entry(
  id: "note 2",
  parent_id: auto,
  title: [Note 2],
  authors: (alice,),
  date: datetime(year: 2026, month: 10, day: 30, hour: 23, minute: 46, second: 0),
  // you can define category for a document
  category: (category.book)(
    publisher: "github",
    isbn: "(none)",
    edition: "0.1.0",
  ),
  tags: (index,),
)[
  Create and render a new document
]

#render-tags(topics)

// Reference a registered target with #lookup("sub note 1", [Sub Note 1]).
// In a context block, backlinks("sub note 1") returns its recorded references.
// render-children([Child notes]) lists children of the current document.
// render-tags(topics) renders the registered tag tree and its rendered notes.
// These views resolve registered targets even when they appear later in the source.
```

### Static site generation

```typst
// Save as site.typ. Requires Typst 0.15+.
// Compile with: typst compile --root . --features html,bundle --format bundle site.typ output
#import "@local/tysty:0.1.0": *
#show: template

// Declare and render the root page explicitly, just like the child pages below.
#entry(id: "home", title: [Notebook], authors: ())[Entry page]

// An embed can declare and emit its own child page. The route is computed
// from the document ID; nested ancestors become route directories.
// when choose ssg generate mode (typst compile --format=bundle),
// `embed` and `entry` must be placed outside a document's main body
#embed[
  #entry(id: "research", parent_id: "home", title: [Research], authors: ())[
    = Research questions
    Research notes.
    == Open problems
    More to explore.
    // The automatic mkoutline selects the route-aware document tree in bundles.
    #mkoutline()
  ]

  #embed[
    #entry(id: "review", parent_id: "research", title: [Review], authors: ())[
      Literature review.
      // embed document rendered to other file
      #ssg.ref("research")
    ]
  ]
]

// Outputs: index.html, research/index.html,
// research/review/index.html, and tysty.css.
// entry uses each document's metadata and parent chain to determine its route.
// Navigation and breadcrumbs are in the top bar; section links appear in the right sidebar.
// mkoutline() uses Typst's outline for PDF/single HTML and SSG routes for bundles.
// Keep page-producing entry calls outside another page's entry body.
```

### UID identifiers

`uid(namespace, name)` uses pure Typst FNV-1a 32 with native integer bit
operations. These identifiers are **non-standard UUIDs that borrow the UUID
container**, not UUID v5. The input is the namespace's 16 bytes followed by the
name's UTF-8 bytes (or raw bytes). Names are preserved without normalization.
The initial hash is 2166136261; each byte is XORed into it, then multiplied by
16777619 modulo 2^32.

The result is `hhhhhhhh-0000-8000-8000-000000000000`, where `hhhhhhhh` is the
lowercase, zero-padded 32-bit hash. The remaining fields are fixed formatting;
they add no entropy. The effective hash space is only 32 bits, so collisions are
possible; this is not a cryptographic hash or a uniqueness guarantee. Namespace
strings remain case-insensitive, and 16-byte namespaces are also accepted.
Existing UUID v5 values and all derived IDs change with this algorithm.

Built-in identifiers use the precomputed FNV-1a 32 table in
`lib/_lib.typ/uid.builtin.json`. Cache keys include the complete namespace and
name; inputs absent from the table are computed with the same pure Typst
implementation. The cache is available during module initialization.

## Plans

## Related Efforts

## Maintainers

[github@mujiu555(暮玖)](https://github.com/mujiu555)

## Contributing

You may pull all repository and walk through any part you interested in.
Make Pr if you have found any problem or have method to improve those notes.

Run `node tests/run.mjs` to test this checkout as `@local/tysty:0.1.0`.
See [tests/README.md](tests/README.md) for API coverage and test targets.

## License

Apache License ver. 2.
