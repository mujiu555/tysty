// Internal aliases: compare source helpers without expanding the public API.
#import "/lib/_lib.typ/lib.typ": *
#import "/lib/_lib.typ/render.typ" as render: mkdoc
#for (automatic, implementation) in (
  (embed, render.embed), (entry, render.entry), (lookup, render.lookup),
  (mkcover, render.mkcover), (mkdoc, render.mkdoc), (mkoutline, render.mkoutline),
  (render-children, render.render-children), (render-tags, render.render-tags),
  (set-base, render.set-base), (template, render.template),
) {
  assert.eq(automatic, implementation)
}
