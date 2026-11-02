// Manual: typst compile --root . tests/reject/uid/namespace_hex.typ /tmp/uid-reject.pdf
// EXPECTED: compilation must fail with: uid namespace must have 8-4-4-4-12 hexadecimal form
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#uid("6ba7b810-9dad-11d1-80b4-00c04fd430cg", "name")
#assert(false, message: "Invalid input was unexpectedly accepted")
