#import "/lib/_lib.typ/doc.typ": documents
#import "/lib/_lib.typ/lib.typ": meta
#meta(id: "child", parent-id: "missing", title: [Child], authors: ())

// Metadata preserves declared parents; rendering validates traversal.
#context {
  assert.eq(documents().map(doc => doc.id), ("child",))
  assert.eq(documents().first().parent-id, "missing")
}
