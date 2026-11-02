// Manual: typst compile --root . tests/reject/uid/name_type.typ /tmp/uid-reject.pdf
// EXPECTED: compilation must fail with: uid name must be a string or bytes
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#uid(namespaces.dns, 12)
#assert(false, message: "Invalid input was unexpectedly accepted")
