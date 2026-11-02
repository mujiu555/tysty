// Manual: typst compile --root . tests/reject/uid/namespace_text.typ /tmp/uid-reject.pdf
// EXPECTED: compilation must fail with: uid namespace must have 8-4-4-4-12 hexadecimal form
#import "/lib/_lib.typ/uid.typ": namespaces, uid
#uid("namespace", "name")
#assert(false, message: "Invalid input was unexpectedly accepted")
