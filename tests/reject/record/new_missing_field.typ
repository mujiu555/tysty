// Function test: reject/record/new_missing_field
// Manual: typst compile --root . tests/reject/record/new_missing_field.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Check the diagnostic manually; unrelated errors are not a passing test.
#import "/lib/_lib.typ/record.typ": record, impl_record
#let R = record(x: int)
#let value = (R.new)()
#assert(false, message: "Invalid input was unexpectedly accepted")
