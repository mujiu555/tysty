// Function test: decorate/decorate_cps
// Manual: typst compile --root . tests/decorate/decorate_cps.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/decorate.typ": decorate-cps
#let wrap = decorate-cps(x => x * 2)
#let basic = wrap()
#assert.eq(basic(3), 6)
#let changed = wrap(after: (next, value, ..rest) => next(value + 1))
#assert.eq(changed(3), 7)
