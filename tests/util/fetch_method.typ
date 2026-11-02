// Function test: util/fetch_method
// Manual: typst compile --root . tests/util/fetch_method.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/util.typ": _fetch_method
#let original = (x: 2)
#let extended = _fetch_method(original, name => () => name, ("first", "second"))
#assert.eq(extended.x, 2)
#assert.eq((extended.first)(), "first")
#assert.eq((extended.second)(), "second")
#assert.eq(original, (x: 2))
