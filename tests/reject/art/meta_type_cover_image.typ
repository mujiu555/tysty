// Manual: typst compile --root . tests/reject/art/meta_type_cover_image.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#let args = (id: "invalid", title: [Title], authors: ()) + (cover_image: "cover.png")
#assert.eq(args.at("cover_image"), "cover.png")
#meta(..args)
