// Manual: typst compile --root . tests/reject/enum/reserved_name.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/enum.typ": enumerator
#let name = sys.inputs.at("name", default: "compare")
#let E = enumerator(..((name): int))
#assert(false, message: "TEST FAILURE: reserved variant was accepted")
