// Function test: record/impl_record
// Manual: typst compile --root . tests/record/impl_record.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let Base = record(x: int)
#let R = impl_record(Base, double: self => self.x * 2)
#let R = impl_record(R, quadruple: self => (self.double)() * 2)
#let r = (R.new)(x: 3)
#assert.eq((r.quadruple)(), 12)
#assert.eq((((R.update)(r, x: 5)).quadruple)(), 20)
#assert(not ("double" in (Base.new)(x: 1)))
