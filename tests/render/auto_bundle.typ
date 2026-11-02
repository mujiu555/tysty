#import "/lib/_lib.typ/render.typ": mkdoc
// Compile with --features html,bundle --format bundle.
#import "/lib/_lib.typ/lib.typ": *
#show: template
#html.page("index.html", title: "Auto HTML")[
  #meta(id: "web", title: [Auto HTML], authors: ())
  #mkdoc[Read #lookup("print", [the PDF]).]
]
#document("print.pdf")[
  #show: template
  #meta(id: "print", title: [Auto PDF], authors: ())
  #mkdoc[Read #lookup("web", [the HTML page]).]
  #context {
    assert.eq(html.entities(), ("web", "print"))
    assert.eq(pdf.entities(), ("web", "print"))
    assert.eq(backlinks("print").first().ctx.payload, "web")
    assert.eq(backlinks("web").first().ctx.payload, "print")
  }
]
