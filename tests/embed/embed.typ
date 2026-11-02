// Function test: embed/embed
// Manual: typst compile --root . tests/embed/embed.typ /tmp/typst-unit-test.pdf
#import "@preview/tysty:0.1.0": *
#meta(id: "root", title: [Root], authors: ())
#embed([
 #context assert.eq(heading.offset, 1)
 #meta(id: "child", title: [Child], authors: ())
 #embed([#context assert.eq(heading.offset, 2)])
 #context assert.eq((current.get)().id, "child")
])
#context {
 assert.eq((current.get)().id, "root")
 assert.eq(heading.offset, 0)
}
