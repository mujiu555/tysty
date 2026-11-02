// Manual: typst compile --root . tests/reject/enum/method_name_collision.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let name = sys.inputs.at("name", default: "payload")
#let E = impl_enum(enumerator(a: int), ..((name): self => 1))
#assert(false, message: "TEST FAILURE: conflicting enum method was accepted")
