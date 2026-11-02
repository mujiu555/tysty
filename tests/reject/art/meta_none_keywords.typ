// Manual: typst compile --root . tests/reject/art/meta_none_keywords.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
// Omitted is different from explicitly none: these schema fields are not nullable.
#let args = (id: "invalid-none", title: [Title], authors: ()) + (keywords: none)
#assert.eq(args.at("keywords"), none)
#meta(..args)
