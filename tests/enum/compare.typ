// Function test: enum/compare
// Manual: typst compile --root . tests/enum/compare.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let Small = enumerator(a: int)
#let Large = enumerator(a: int, b: str)
#assert((Large.compare)(Small))
#assert(not (Small.compare)(Large))
#assert(not (Small.compare)(enumerator(a: str)))
#assert(not (Small.compare)(int))
