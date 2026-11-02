// Manual: typst compile --root . tests/reject/art/meta_missing_authors.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#let args = (id: "required", title: [Title])
#assert(not ("authors" in args))
#meta(..args)
