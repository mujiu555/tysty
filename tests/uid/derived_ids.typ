// Manual: typst compile --root . tests/uid/derived_ids.typ /tmp/uid-derived_ids.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/record.typ": _record_uid
#import "/lib/_lib.typ/enum.typ": _enum_uid
#import "/lib/_lib.typ/tag.typ": _tag_uid
#import "/lib/_lib.typ/state.typ": _state_uid
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#let generators = (_record_uid, _enum_uid, _tag_uid, _state_uid)
#assert.eq(generators.map(make => make("same")).dedup().len(), 4)
#for make in generators {
  assert.eq(make("same"), make("same"))
  assert(make("same") != make("other"))
}
// IDs can serve as namespaces for another level of derivation.
// Independent reference: apply FNV-1a 32 and container encoding twice.
#assert.eq(uid(uid(namespaces.dns, "parent"), "child"), "e69b479c-0000-8000-8000-000000000000")
