// Manual: typst compile --root . tests/reject/art/meta_type_date.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#let args = (id: "invalid", title: [Title], authors: ()) + (date: "2025-01-01")
#assert.eq(args.at("date"), "2025-01-01")
#meta(..args)
