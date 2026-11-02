// Function test: record/update
// Manual: typst compile --root . tests/record/update.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: int, y: int)
#let old = (R.new)(x: 2, y: 4)
#let updated = (R.update)(old, x: 8)
#assert.eq((updated.fields)(), (x: 8, y: 4))
#assert.eq(old.x, 2, message: "update must not mutate the original")
