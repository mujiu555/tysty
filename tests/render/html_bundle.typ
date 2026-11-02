// typst compile --root . --features html,bundle --format bundle tests/render/html_bundle.typ /tmp/tysty-html-bundle
#import "@preview/tysty:0.1.0": *
#import "/tests/fixtures/png.typ": png
#show: html.bundle
#let tree = (tag.register)("topics", (science: (:),))
#let science = tree.children.science.tag

#html.page("index.html", title: "Notebook & notes")[
  #meta(id: "root", title: [Notebook & notes], authors: ("Alice",), tags: (science,), cover_image: (img.data)(png))
  #html.mkcover()
  #html.mkdoc[
    #html.lookup("child", [Read the child])
    #html.render-children([Children])
    #html.render-tags(tree)
  ]
]

#html.page("notes/child.html", title: "Child")[
  #meta(id: "child", parent-id: "root", title: [Child], authors: ())
  #html.mkdoc[
    #html.lookup("root", [Return to root])
    #embed[
      #meta(id: "nested", parent-id: "child", title: [Nested], authors: ())
      #html.mkdoc(new-page: false)[Nested content.]
    ]
    #html.lookup("root", [Restored child context])
  ]
  #context {
    assert.eq((current.get)().id, "child")
    assert.eq(indexers().map(index => index.label), ("root", "child", "nested", "standalone"))
    assert.eq(backlinks("root").map(r => r.ctx.payload), ("child", "child"))
    assert.eq(backlinks("child").first().ctx.payload, "root")
  }
]

#html.page("standalone.html", title: "Standalone index")[
  #mkindex("standalone", [Independent target])
  #html.lookup("standalone", [Independent reference])
  #context {
    assert.eq((current.get)(), (:))
    assert.eq(backlinks("standalone").first().ctx.variant, "null")
  }
]
