// Function test: indexer/mkindex_indexers
// Manual: typst compile --root . tests/indexer/mkindex_indexers.typ /tmp/typst-unit-test.pdf
#import "@preview/tysty:0.1.0": *
#mkindex("unit", [Target])
#context {
 let entries = indexers()
 assert.eq(entries.map(index => index.label), ("unit",))
 assert.eq(entries.first().label, "unit")
 assert.eq(entries.first().content, [Target])
 assert.eq(type(entries.first().loc), location)
 assert.eq(query(<typst-mode-index-label>).len(), 1)
}
