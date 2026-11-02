// Manual: typst compile --root . tests/reject/record/new_unknown_argument.typ /tmp/typst-test.pdf
// Expected rejection. If compilation reaches the final assertion, the constructor
// silently accepted the unknown field. That diagnostic is a TEST FAILURE.
#import "/lib/_lib.typ/record.typ": record
#let R = record(x: int)
#let r = (R.new)(x: 1, misspelled: 10)
#assert(false, message: "TEST FAILURE: new silently accepted unknown argument misspelled")
