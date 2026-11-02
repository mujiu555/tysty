// Manual: typst compile --root . tests/reject/art/meta_none_parent_id.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
// Omitted is different from explicitly none: these schema fields are not nullable.
#let args = (id: "invalid-none", title: [Title], authors: ()) + (parent_id: none)
#assert.eq(args.at("parent_id"), none)
#meta(..args)
