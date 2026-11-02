#import "@preview/tysty:0.1.0": mkindex, indexers, lookup

// Ordinary labels and unrelated metadata must not enter the index or its lookup.
Ordinary target <unit>
#metadata("unrelated") <other-metadata>
#lookup("unit", [Forward])
#lookup("unit:child", [Other forward])
#pagebreak()
#mkindex("unit", [Target])
#mkindex("unit:child", [Child])

#context {
  let entries = indexers()
  assert.eq(entries.map(index => index.label), ("unit", "unit:child"))
  assert.eq(entries.first().content, [Target])
  assert.eq(entries.at(1).content, [Child])
  let links = query(link)
  assert.eq(links.len(), 2)
  assert.eq(links.at(0).dest, entries.first().loc)
  assert.eq(links.at(1).dest, entries.at(1).loc)
  assert.eq(entries.first().loc.page(), 2)
}
