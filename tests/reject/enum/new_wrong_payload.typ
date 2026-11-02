// Function test: reject/enum/new_wrong_payload
// Manual: typst compile --root . tests/reject/enum/new_wrong_payload.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Check the diagnostic manually; unrelated errors are not a passing test.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(a: int)
#let value = (E.a)("bad")
#assert(false, message: "Invalid input was unexpectedly accepted")
