#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Function test: render/mkcover
// Manual: typst compile --root . tests/render/mkcover.typ /tmp/typst-unit-test.pdf
#import "@preview/tysty:0.1.0": *
#meta(id: "unit", title: [Title], authors: ("Alice",))
#pdf.mkcover()
#context {
 assert.eq(rendered-text().matches(regex("Title")).len(), 1)
 assert(rendered-text().contains("Title"))
 assert.eq(indexers().map(index => index.label), ("unit",), message: "Cover must register its document target exactly once")
}
