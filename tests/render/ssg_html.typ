// Outside a bundle, ssg.mkdoc falls back to HTML rendering.
#import "@preview/tysty:0.1.0": *
#show: html.template
#meta(id: "single", title: [Single SSG fallback], authors: ())
#ssg.mkdoc[Fallback body.]
#context {
  assert.eq(indexers().map(index => index.label), ("single",))
  assert(not ssg.is-bundle-output())
  assert.eq(ssg.entities(), ())
  assert.eq(html.entities(), ("single",))
}
