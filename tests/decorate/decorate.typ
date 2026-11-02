// Function test: decorate/decorate
// Manual: typst compile --root . tests/decorate/decorate.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/decorate.typ": decorate
#let identity = decorate((a, b: 2) => a + b)
#assert.eq(identity(3, b: 4), 7)
#let wrapped = decorate(
 x => x * 2,
 prev: x => assert.eq(x, 3),
 before: (x, offset: 0) => arguments(x + offset),
 after: (x, offset: 0) => x + offset,
 fwd: x => assert.eq(x, 13),
)
#assert.eq(wrapped(3, _b: (offset: 2), _a: (offset: 3)), 13)
