// Manual: typst compile --root . tests/reject/tag/meta_invalid_none.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#let bad = none
#assert.eq((bad,).len(), 1)
#meta(id: "invalid-tag", title: [Invalid], authors: (), tags: (bad,))
