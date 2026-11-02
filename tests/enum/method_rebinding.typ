// Manual: typst compile --root . tests/enum/method_rebinding.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/enum.typ": enumerator, impl_enum
#let E = impl_enum(enumerator(a: int), result: self => self.payload + 1)
#let old = (E.a)(3)
#let E = impl_enum(E, result: self => self.payload + 2)
#let fresh = (E.a)(3)
#assert.eq((old.result)(), 4)
#assert.eq((fresh.result)(), 5)
#assert.eq(fresh.variant, "a")
#assert.eq(fresh.payload, 3)
