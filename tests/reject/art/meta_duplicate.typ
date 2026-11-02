// Function test: reject/art/meta_duplicate
// Manual: typst compile --root . tests/reject/art/meta_duplicate.typ /tmp/typst-unit-test.pdf
// EXPECTED: compilation must fail at the invalid operation below.
// Check the diagnostic manually; unrelated errors are not a passing test.
#import "@preview/tysty:0.1.0": *
#meta(id: "a", title: [A], authors: ())
#meta(id: "a", title: [A], authors: ())
#context assert.eq(query(<typst-mode-document-id>).len(), 2)
