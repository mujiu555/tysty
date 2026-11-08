// typst compile --root . tests/render/pdf_namespace.typ /tmp/tysty-pdf-namespace.pdf
#import "@preview/tysty:0.1.0": *
#show: pdf.template
#let tree = (tag.register)("topics", (science: (:),))
#meta(id: "root", title: [Root], authors: ())
#pdf.mkdoc(cover: true)[
  #pdf.lookup("child", [Child reference])
  #pdf.render-children([Children])
  #pdf.embed[
    #meta(id: "child", parent-id: "root", title: [Child], authors: (), tags: (tree.children.science.tag,))
    #pdf.mkdoc[Child content.]
  ]
  #pdf.render-tags(tree)
]
#context {
  assert.eq(indexers().map(index => index.label), ("root", "child"))
  assert.eq(backlinks("child").len(), 1)
  assert.eq(backlinks("child").first().ctx.payload, "root")
}
