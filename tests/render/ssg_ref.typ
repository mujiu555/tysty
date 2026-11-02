// Bundle generation and ref embed the saved body, preserving document scope.
#import "@preview/tysty:0.1.0": *
#show: template
#meta(id: "home", title: [Home], authors: ())
#ssg.mkdoc[
  Root body.
  #ssg.ref("snippet")
  #context assert.eq((current.get)().id, "home")
  #ssg.mkoutline()
]
#ssg.embed[
  #meta(id: "snippet", parent_id: "home", title: [Snippet], authors: ())
  #ssg.mkdoc[
    SHARED-SNIPPET-BODY
    #context {
      assert.eq((current.get)().id, "snippet")
      assert(ssg.is-bundle-output())
    }
  ]
]
#context assert.eq((current.get)().id, "home")
