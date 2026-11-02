#import "/lib/_lib.typ/doc.typ": documents
#import "/lib/_lib.typ/lib.typ": *
#import "/tests/fixtures/png.typ": png

#let alice = (author.new)(name: "Alice", affiliation: "Lab", email: "a@example.com", home: "https://example.com/", orcid: "0000-0000")
#assert.eq((alice.fields)().name, "Alice")
#assert.eq(((author.update)(alice, name: "Bob")).name, "Bob")
#let make-author = (author.with)(affiliation: "Lab", email: "", home: "", orcid: "")
#assert.eq(make-author(name: "Carol").name, "Carol")
#assert((author.compare)(author))
#assert.eq((img.path)("cover.png").payload, "cover.png")
#assert.eq((img.data)(png).payload, png)
#assert.eq(img.null.variant, "null")

#let tree = (tag.register)("api", (science: (physics: (:),), empty: (:)))
#let science = tree.children.science.tag
#let physics = tree.children.science.children.physics.tag
#let child = (physics.sub)("optics")
#assert.eq(science._parent, tree.tag.id)
#assert.eq(physics._parent, science.id)
#assert.eq(child._parent, physics.id)
#assert.eq(child.name, "optics")
#assert.eq((physics.sub)("optics").id, child.id)
#assert(child.id != (science.sub)("optics").id)
#assert.eq(tree.children.empty.children, (:))
#meta(id: "root", title: [Root], authors: (alice, "Bob"), tags: (science,))
#meta(id: "child", parent_id: "root", title: [Child], authors: (), tags: (physics,))
#context {
  assert.eq((science.get-doc)().map(d => d.id), ("root",))
  assert.eq((physics.get-doc)().map(d => d.id), ("child",))
  assert.eq((tree.tag.get-doc)(), ())
  assert.eq((child.get-doc)(), ())
  assert.eq(documents().find(doc => doc.id == "root").authors.first().home, alice.home)
}
