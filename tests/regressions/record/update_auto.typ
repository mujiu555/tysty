// Function test: regressions/record/update_auto
// Manual: typst compile --root . tests/regressions/record/update_auto.typ /tmp/typst-unit-test.pdf
// Regression: updating an auto-valued field must preserve its value.
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: type(auto))
#let r = (R.new)(x: auto)
#let r2 = (R.update)(r, x: auto)


#assert.eq(r2.x, auto)
