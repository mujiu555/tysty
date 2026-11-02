// typst compile --root . --features html,bundle --format bundle tests/render/ssg.typ /tmp/tysty-ssg
#import "@preview/tysty:0.1.0": *
#show: template

// Calculate routes before emitting bundle documents. Bundle pages are
// top-level outputs; keep them outside another mkdoc body.
#assert.eq(ssg.route("home", root: true), "index.html")
#assert.eq(ssg.route("Research"), "research/index.html")
#assert.eq(ssg.route("Lit Review", ancestors: ("Research",)), "research/lit-review/index.html")
#assert.eq(ssg.route("  !!!  "), "untitled/index.html")
#assert.eq(ssg.route("Guides/Setup"), "guides/setup/index.html")
#assert.eq(ssg.route("中文 笔记"), "中文-笔记/index.html")

#meta(id: "home", title: [Home], authors: ())
#ssg.mkdoc[Home page.]
#ssg.embed[
  #meta(id: "research", parent_id: "home", title: [Research], authors: ())
  #ssg.mkdoc[
    = Research questions
    Research notes.
    == Open problems
    More to explore.
    #heading(outlined: false)[Hidden section]
    #context heading[Dynamic section]
    #mkoutline()
  ]
  #ssg.embed[
    #meta(id: "review", parent_id: "research", title: [Literature review], authors: ())
    #ssg.mkdoc[Review content.]
  ]
]
#context {
  assert.eq((current.get)().id, "home")
  assert.eq(ssg.entities(), ("home", "research", "review"))
  assert.eq(html.documents().find(doc => doc.id == "review").parent_id, "research")
}
