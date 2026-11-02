// Function test: enum/impl_enum
// Manual: typst compile --root . tests/enum/impl_enum.typ /tmp/typst-unit-test.pdf
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = enumerator(a: int, b: str)
#let E = impl_enum(E, kind: self => self.variant)
#let E = impl_enum(E, describe: self => "kind=" + (self.kind)())
#assert.eq((((E.a)(1)).describe)(), "kind=a")
#assert.eq((((E.b)("x")).describe)(), "kind=b")
