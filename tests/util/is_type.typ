// Function test: util/is_type
// Manual: typst compile --root . tests/util/is_type.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#import "/lib/_lib.typ/util.typ": _is_type
#assert(_is_type(int))
#assert(_is_type(record(x: int)))
#assert(_is_type(enumerator(a: int)))
#assert(not _is_type(none))
#assert(not _is_type((:)))
#assert(not _is_type((record(x: int).new)(x: 1)))
