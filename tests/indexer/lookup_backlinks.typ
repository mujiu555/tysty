// Function test: indexer/lookup_backlinks
// Manual: typst compile --root . tests/indexer/lookup_backlinks.typ /tmp/typst-unit-test.pdf
#import "@preview/tysty:0.1.0": lookup, mkindex, indexers, backlinks
#context assert.eq(backlinks("unit").map(r => r.content), ([First], [Second]))
#lookup("unit", [First])
#mkindex("unit", [Target])
#lookup("unit", [Second])
#context {
 let refs = backlinks("unit")
 assert.eq(refs.len(), 2)
 assert.eq(refs.map(r => r.content), ([First], [Second]))
 assert.eq(backlinks("missing"), ())
 assert.eq(query(link).len(), 2)
 for l in query(link) { assert.eq(l.dest, indexers().first().loc) }
}
