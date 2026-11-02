// Manual: typst compile --root . tests/reject/uid/namespace_type.typ /tmp/uid-reject.pdf
// EXPECTED: compilation must fail with: uid namespace must be an identifier string or bytes
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#uid(12, "name")
#assert(false, message: "Invalid input was unexpectedly accepted")
