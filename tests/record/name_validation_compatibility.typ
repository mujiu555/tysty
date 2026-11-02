// Manual: typst compile --root . tests/record/name_validation_compatibility.typ /tmp/name-validation.pdf
// Rejection cases also accept --input name=NAME; inspect the named diagnostic.
#import "/lib/_lib.typ/record.typ": record, impl_record
// These instance fields do not overwrite type-level metadata or constructors.
#let R = record(_parent: str, description: str, new: int)
#let r = (R.new)(_parent: "root", description: "user data", new: 7)
#assert.eq((r.fields)(), (_parent: "root", description: "user data", new: 7))
// An instance update method must coexist with the type's copy-and-replace update.
#let S = impl_record(record(x: int), update: (self, delta) => self.x + delta)
#let s = (S.new)(x: 2)
#assert.eq((s.update)(3), 5)
#assert.eq((((S.update)(s, x: 7)).update)(3), 10)
// Existing custom methods may be rebound; existing instances retain old methods.
#let T = impl_record(S, answer: self => self.x * 2)
#let old = (T.new)(x: 4)
#let T = impl_record(T, answer: self => self.x * 3)
#assert.eq((old.answer)(), 8)
#assert.eq((((T.new)(x: 4)).answer)(), 12)
