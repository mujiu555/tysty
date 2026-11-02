// Manual: typst compile --root . tests/fixtures/png.typ /tmp/typst-expanded-test.pdf
// Expected: successful compilation and all assertions pass.
// Self-contained 2x2 pale-blue PNG, encoded as bytes so no binary fixture is needed.
#let png = bytes((137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 2, 0, 0, 0, 2, 8, 6, 0, 0, 0, 114, 182, 13, 36, 0, 0, 0, 17, 73, 68, 65, 84, 120, 156, 99, 216, 119, 253, 215, 127, 16, 102, 128, 49, 0, 126, 62, 14, 57, 143, 238, 147, 64, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130,))
#assert.eq(png.slice(0, 8), bytes((137, 80, 78, 71, 13, 10, 26, 10)))
