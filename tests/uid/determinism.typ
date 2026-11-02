// Manual: typst compile --root . tests/uid/determinism.typ /tmp/uid-determinism.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#for ns in namespaces.values() {
  let id = uid(ns, "unit")
  assert.eq(id, uid(ns, "unit"))
  assert(id != uid(ns, "other"))
}
#assert.eq(namespaces.values().map(ns => uid(ns, "unit")).dedup().len(), 4)
