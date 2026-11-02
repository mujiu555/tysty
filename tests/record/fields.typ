// Function test: record/fields
// Manual: typst compile --root . tests/record/fields.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: int, name: str)
#let r = (R.new)(x: 2, name: "test")
#assert.eq((r.fields)(), (x: 2, name: "test"))
