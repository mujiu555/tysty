#import "/lib/_lib.typ/doc.typ": documents
#import "/lib/_lib.typ/lib.typ": meta
#meta(id: "a", parent-id: "b", title: [A], authors: ())
#meta(id: "b", parent-id: "a", title: [B], authors: ())

// Metadata preserves declared parents; rendering validates traversal.
#context {
  assert.eq(documents().map(doc => doc.id), ("a","b",))
  assert.eq(documents().first().parent-id, "b")
}
