// Function test: record/with
// Manual: typst compile --root . tests/record/with.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: int, y: int)
#let make = (R.with)(x: 2)
#assert.eq((make(y: 4).fields)(), (x: 2, y: 4))
#assert.eq(make(y: 9).y, 9)
