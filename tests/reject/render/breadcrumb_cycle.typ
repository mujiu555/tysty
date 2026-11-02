#import "/lib/_lib.typ/render.typ": mkdoc
#import "/lib/_lib.typ/lib.typ": *
#show: template
#meta(id: "a", parent-id: "b", title: [A], authors: ())
#mkdoc[First.]
#meta(id: "b", parent-id: "a", title: [B], authors: ())
#mkdoc[Second.]
