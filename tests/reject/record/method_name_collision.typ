// Manual: typst compile --root . tests/reject/record/method_name_collision.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/record.typ": record, impl_record
#let name = sys.inputs.at("name", default: "x")
#let R = impl_record(record(x: int), ..((name): self => 1))
#assert(false, message: "TEST FAILURE: conflicting method was accepted")
