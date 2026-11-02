// Function test: state/mkstate
// Manual: typst compile --root . tests/state/mkstate.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/state.typ": _mkstate
#let a = _mkstate("unit-a", 2)
#let b = _mkstate("unit-b", 9)
#context assert.eq((a.get)(), 2)
#(a.update)(v => v + 3)
#metadata("checkpoint") <checkpoint>
#(a.update)(8)
#context {
  assert.eq((a.get)(), 8)
  assert.eq((a.at)(<checkpoint>), 5)
  assert.eq((a.final)(), 8)
  assert.eq((b.final)(), 9)
}
