#import "record.typ": impl_record, record
#import "enum.typ": enumerator, impl_enum

#let _cell_cont = enumerator(
  inum: int,
  dec: decimal,
  text: content,
  logic: bool,
  error: int,
  formular: function,
)

#let cell = record(
  ctnt: _cell_cont,
  loc: int,
)

#let sheet = record(
  lines: array,
)
