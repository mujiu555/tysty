// Manual: typst compile --root . tests/reject/record/new_none.typ /tmp/typst-test.pdf
// Expected rejection: current record contract requires enums for null alternatives.
#import "/lib/_lib.typ/record.typ": record
#let R = record(x: type(none))
#let r = (R.new)(x: none)
#assert(false, message: "TEST FAILURE: nullable record field was accepted")
