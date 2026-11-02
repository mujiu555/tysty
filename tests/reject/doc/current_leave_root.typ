// Function test: reject/doc/current_leave_root
// Manual: typst compile --root . tests/reject/doc/current_leave_root.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Check the diagnostic manually; unrelated errors are not a passing test.
#import "@preview/tysty:0.1.0": current
#(current.leave)()
#context assert.eq(type((current.get)()), dictionary)
