// typst compile --root . --features html tests/render/html_single.typ /tmp/tysty-single.html
#import "@preview/tysty:0.1.0": *
#show: html.template.with(title: "Single <notebook>", lang: "zh")
#meta(id: "root", title: [笔记], authors: ())
#html.mkdoc[
  #html.lookup("later", [Forward reference])
  #html.render-children([Children])
]
#meta(id: "later", parent_id: "root", title: [Later], authors: ())
#html.mkdoc[Later content.]
#html.embed[
  #meta(id: "embedded", title: [Embedded], authors: ())
  #context assert.eq((current.get)().id, "embedded")
]
#context {
  assert.eq((current.get)().id, "later")
  assert.eq(backlinks("later").len(), 1)
  assert.eq(backlinks("later").first().ctx.payload, "root")
}
