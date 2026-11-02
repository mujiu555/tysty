// Manual: typst compile --root . tests/uid/boundaries.typ /tmp/uid-boundaries.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#assert(uid(namespaces.dns, "a") != uid(namespaces.dns, "b"))
#assert(uid(namespaces.dns, "") != uid(namespaces.dns, " "))
#assert(uid(namespaces.dns, "Name") != uid(namespaces.dns, "name"))
// Exercise empty, short, and long names, including former SHA-1 boundaries.
// Reference values from an independent Python FNV-1a 32 implementation.
#let cases = (
  (38, "249a09bc-0000-8000-8000-000000000000"),
  (39, "627d5f8c-0000-8000-8000-000000000000"),
  (40, "ff5e0d1c-0000-8000-8000-000000000000"),
  (41, "650f146c-0000-8000-8000-000000000000"),
  (47, "c60a3b0c-0000-8000-8000-000000000000"),
  (48, "361b979c-0000-8000-8000-000000000000"),
  (49, "11701bec-0000-8000-8000-000000000000"),
  (103, "50327b8c-0000-8000-8000-000000000000"),
  (104, "3379211c-0000-8000-8000-000000000000"),
  (111, "3bc6d70c-0000-8000-8000-000000000000"),
  (112, "8e052b9c-0000-8000-8000-000000000000"),
  (4096, "64c7889c-0000-8000-8000-000000000000"),
)
#for (length, expected) in cases {
  assert.eq(uid(namespaces.dns, "x" * length), expected)
}
