// Manual: typst compile --root . tests/reject/indexer/mkindex_nested_duplicate.typ /tmp/typst-expanded-test.pdf
// Expected: compilation error from the invalid input; inspect the diagnostic manually.
#import "@preview/tysty:0.1.0": *
#mkindex("same", [Outer #mkindex("same", [Inner])])
#context assert.eq(query(<typst-mode-index-label>).len(), 2)
