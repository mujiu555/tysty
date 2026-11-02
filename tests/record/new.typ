// Function test: record/new
// Manual: typst compile --root . tests/record/new.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: int, name: str)
#let r = (R.new)(x: 2, name: "test")
#assert.eq(r.x, 2)
#assert.eq(r.name, "test")
#assert((R.compare)(r._type))
#let Empty = record()
#assert.eq(((Empty.new)().fields)(), (:))
