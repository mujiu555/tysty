// Manual: typst compile --root . tests/uid/vectors.typ /tmp/uid-vectors.pdf
// Expected: successful compilation and all assertions pass.
#import "/lib/_lib.typ/uid.typ": namespaces, uid
// Regression vectors from an independent Python FNV-1a 32 implementation.
#assert.eq(uid(namespaces.dns, ""), "6aa2889c-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.dns, "name"), "7dd17897-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.url, "https://example.com/"), "ee88a626-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.oid, "1.3.6.1"), "2b76be37-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.x500, "CN=example"), "8c4fd8be-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.dns, "笔记🚀"), "cd7d325a-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.dns, "é"), "f3648fac-0000-8000-8000-000000000000")
#assert.eq(uid(namespaces.dns, "é"), "a633b87c-0000-8000-8000-000000000000")
// Raw binary name, including NUL and bytes that are not valid UTF-8.
#assert.eq(uid(namespaces.dns, bytes((0, 255, 128, 1))), "3c83f246-0000-8000-8000-000000000000")
