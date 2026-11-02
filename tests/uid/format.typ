// Manual: typst compile --root . tests/uid/format.typ /tmp/uid-format.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Independent FNV-1a 32 vectors in the fixed UUID container.
#let cases = (
  ("variant-0", "1f76f540-0000-8000-8000-000000000000"),
  ("variant-1", "2076f6d3-0000-8000-8000-000000000000"),
  ("variant-3", "2276f9f9-0000-8000-8000-000000000000"),
  ("variant-6", "2576feb2-0000-8000-8000-000000000000"),
)
#for (name, expected) in cases {
  let value = uid(namespaces.dns, name)
  assert.eq(value, expected)
  assert.eq(value.split("-").map(part => part.len()), (8, 4, 4, 4, 12))
  assert.eq(value.len(), 36)
  assert.eq(value.at(14), "8")
  assert.eq(value.slice(8), "-0000-8000-8000-000000000000")
  assert.eq(value, lower(value))
}
