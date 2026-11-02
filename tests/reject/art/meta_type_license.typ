// Manual: typst compile --root . tests/reject/art/meta_type_license.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#let args = (id: "invalid", title: [Title], authors: ()) + (license: 5)
#assert.eq(args.at("license"), 5)
#meta(..args)
