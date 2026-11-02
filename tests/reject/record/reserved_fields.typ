// Manual: typst compile --root . tests/reject/record/reserved_fields.typ /tmp/typst-test.pdf
// Expected rejection at the declaration, before the sentinel assertion.
#import "/lib/_lib.typ/record.typ": record
#let R = record(fields: str)
#assert(false, message: "TEST FAILURE: reserved field fields was accepted")
