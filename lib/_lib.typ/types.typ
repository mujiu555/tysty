
#import "record.typ": record
#import "enum.typ": enumerator

#let author = record(
  name: str,
  affiliation: str,
  email: str,
  home: str,
  orcid: str,
)

#let img = enumerator(
  path: str,
  data: bytes,
  null: record(),
)
#let img = img + (null: (img.null)())

// Tagged union: `variant` selects the publication type, `content` carries
// the type-specific fields.
#let category = enumerator(
  "Publication category",
  journal: record(
    journal: str,
    volume: int,
    issue: int,
    pages: str,
  ),
  conference: record(
    conference: str,
    proceedings: str,
  ),
  book: record(
    publisher: str,
    isbn: str,
    edition: str,
  ),
  bookChapter: record(
    book: str,
    pages: str,
  ),
  thesis: record(
    degree: str,
    university: str,
  ),
  report: record(
    institution: str,
    number: str,
  ),
  preprint: record(
    repository: str,
    platform: str,
  ),
  blogPost: record(
    site: str,
    series: str,
  ),
  null: record(),
)

#let category = category + (null: (category.null)())
