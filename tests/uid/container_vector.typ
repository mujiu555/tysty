// Manual: typst compile --root . tests/uid/container_vector.typ /tmp/uid-container_vector.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Familiar DNS input, now hashed with FNV-1a 32 rather than UUID v5.
#let expected = "7511530c-0000-8000-8000-000000000000"
#assert.eq(namespaces.dns, "6ba7b810-9dad-11d1-80b4-00c04fd430c8")
#assert.eq(uid(namespaces.dns, "www.example.com"), expected)
// Equivalent raw bytes and case-insensitive namespace spelling.
#let dns-bytes = bytes((107, 167, 184, 16, 157, 173, 17, 209, 128, 180, 0, 192, 79, 212, 48, 200))
#assert.eq(uid(dns-bytes, bytes("www.example.com")), expected)
#assert.eq(uid(upper(namespaces.dns), "www.example.com"), expected)
