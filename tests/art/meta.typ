#import "/lib/_lib.typ/doc.typ": documents
// Function test: art/meta
// Manual: typst compile --root . tests/art/meta.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/lib.typ": *
#meta(id: "unit", title: [Title], authors: ("Alice",), abstract: "Abstract")
#context {
 assert.eq(type(documents()), array)
 let d = (current.get)()
 assert.eq(d.id, "unit")
 assert.eq(d.title, [Title])
 assert.eq(d.authors, ("Alice",))
 assert.eq(d.abstract, "Abstract")
 assert.eq(d.category.variant, "null")
 assert.eq(d.cover_image.variant, "null")
 assert.eq(documents().map(doc => doc.id), ("unit",))
 assert.eq(query(<tysty-document>).len(), 1)
}
