// Manual: typst compile --root . tests/reject/uid/namespace_bytes.typ /tmp/uid-reject.pdf
// EXPECTED: compilation must fail with: uid namespace must contain 16 bytes
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#uid(bytes("ns"), "name")
#assert(false, message: "Invalid input was unexpectedly accepted")
