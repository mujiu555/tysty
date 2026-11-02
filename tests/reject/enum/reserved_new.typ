// Manual: typst compile --root . tests/reject/enum/reserved_new.typ /tmp/typst-test.pdf
// Expected rejection at the declaration, before the sentinel assertion.
#import "/lib/_lib.typ/enum.typ": enumerator
#let E = enumerator(new: int)
#assert(false, message: "TEST FAILURE: reserved variant new was accepted")
