// Consumer contract: every supported top-level entry is imported from the package.
#import "@preview/tysty:0.1.0": meta, backlinks, indexers, mkindex, tag, author, category, img, current, pdf, html, ssg, embed, entry, lookup, mkcover, mkdoc, mkoutline, num, render-children, render-tags, set-base, template
#for fn in (meta, backlinks, indexers, mkindex, embed, entry, lookup, mkcover, mkdoc, mkoutline, num, render-children, render-tags, set-base, template) {
  assert.eq(type(fn), function)
}
#for renderer in (pdf, html) {
  for fn in (renderer.embed, renderer.lookup, renderer.mkcover, renderer.mkdoc, renderer.render-children, renderer.render-tags, renderer.template) {
    assert.eq(type(fn), function)
  }
}
#assert.eq(type(ssg.mkoutline), function)
#assert.eq(type(ssg.ref), function)
#assert.eq(type(html.stylesheet), str)
#assert(html.stylesheet.len() > 0)
