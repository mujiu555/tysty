// Manual: typst compile --root . tests/reject/record/update_unknown_argument.typ /tmp/typst-test.pdf
// Expected rejection before the final sentinel assertion.
#import "/lib/_lib.typ/record.typ": record
#let R = record(x: int)
#let r = (R.new)(x: 1)
#let updated = (R.update)(r, misspelled: 10)
#assert(false, message: "TEST FAILURE: update silently accepted unknown argument misspelled")
