// Function test: util/match
// Manual: typst compile --root . tests/util/match.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#import "/lib/_lib.typ/util.typ": _match, _type_accepts
#let R = record(x: int)
#assert(_match(int, 3))
#assert(not _match(int, "3"))
#assert(_match(R, (record(x: int, y: str).new)(x: 2, y: "x")))
#assert(not _match(R, (x: 2)))
#assert(not _match(R, (record(x: str).new)(x: "2")))
#assert(_type_accepts(int, int))
#assert(not _type_accepts(int, str))
