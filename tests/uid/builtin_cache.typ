// Manual: typst compile --root . tests/uid/builtin_cache.typ /tmp/uid-builtin-cache.pdf
// Check every precomputed entry against computation, bypassing the cache.
#import "/lib/_lib.typ/uid.typ": uid, namespaces
#import "/lib/_lib.typ/uid.pure.typ": _uid_compute
#let entries = json("/lib/_lib.typ/uid.builtin.json")
#assert(entries.len() > 0)
#for (namespace, name, expected) in entries {
  assert.eq(expected, _uid_compute(namespace, name))
  assert.eq(uid(namespace, name), expected)
  assert.eq(uid(upper(namespace), name), expected)
  assert.eq(uid(namespace, bytes(name)), expected)
}
// A schema that is absent from the table falls back to the same algorithm.
#assert.eq(uid(namespaces.dns, "uncached-schema"), _uid_compute(namespaces.dns, "uncached-schema"))
