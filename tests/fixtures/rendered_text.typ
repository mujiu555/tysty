// Manual: typst compile --root . tests/fixtures/rendered_text.typ /tmp/rendered-text.pdf
// Observe rendered text using locatable metadata; text itself is not queryable.
#let observe-text(it) = [#metadata(it.text)<test-rendered-text>#it]
#let rendered-text() = {
  let parts = query(<test-rendered-text>).map(m => m.value)
  if parts.len() == 0 { "" } else { parts.join("") }
}
#context assert.eq(rendered-text(), "", message: "No observed text must produce an empty string")
