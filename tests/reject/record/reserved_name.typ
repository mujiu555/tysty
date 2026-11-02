// Manual: typst compile --root . tests/reject/record/reserved_name.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/record.typ": record
#let name = sys.inputs.at("name", default: "_type")
#let R = record(..((name): int))
#assert(false, message: "TEST FAILURE: reserved field was accepted")
