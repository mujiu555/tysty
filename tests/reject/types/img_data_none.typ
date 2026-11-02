// Manual: typst compile --root . tests/reject/types/img_data_none.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#assert.eq(type(img.data), function)
#let value = (img.data)(none)
