#import "/tests/fixtures/rendered_text.typ": observe-text, rendered-text
#show text: observe-text
// Manual: typst compile --root . tests/render/mkcover_png_background.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
#import "@preview/tysty:0.1.0": *
#import "/tests/fixtures/png.typ": png
#set page(width: 160mm, height: 240mm, margin: 12mm, background: [
 #image(png, width: 100%, height: 100%, fit: "stretch")
 #metadata("PNG background") <png-background>
])
#meta(id: "png-cover", title: [PNG cover], authors: (), cover_image: (img.data)(png))
#pdf.mkcover()
#context {
 assert(query(<png-background>).len() >= 1, message: "Background must be laid out")
 assert(query(image).len() >= 2, message: "PNG image elements must be laid out")
 assert.eq(rendered-text().matches(regex("PNG cover")).len(), 1)
 assert.eq(counter(page).final().first(), 1, message: "Normal-size cover should fit one page")
 assert.eq((current.get)().cover_image.payload, png)
}
// Manual visual check: pale-blue background behind readable title.
