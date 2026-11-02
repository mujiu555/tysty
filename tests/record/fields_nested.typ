// Manual: typst compile --root . tests/record/fields_nested.typ /tmp/typst-test.pdf
#import "/lib/_lib.typ/record.typ": record
#import "/lib/_lib.typ/enum.typ": enumerator
#let Point = record(x: int)
#let Choice = enumerator(point: Point, number: int)
#let Container = record(child: Point, choice: Choice)
#let value = (Container.new)(child: (Point.new)(x: 2), choice: (Choice.point)(x: 3))

#let I = record(i: int)
#let F = record(n: I)
#let C = record(f: F)
#let v = (C.new)(f: (F.new)(n: (I.new)(i: 10)))

#(v.fields)()
