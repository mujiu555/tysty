// Function test: record/compare
// Manual: typst compile --root . tests/record/compare.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/record.typ": record, impl_record
#let Small = record(x: int)
#let Large = record(x: int, y: str)
#assert((Small.compare)(Large))
#assert(not (Large.compare)(Small))
#assert(not (Small.compare)(record(x: str)))
#assert(not (Small.compare)(int))
#assert((record(child: Small).compare)(record(child: Large)))
