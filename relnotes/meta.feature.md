* `ocean.meta.types.Qualifiers`

  Moved `istring`/`cstring`/`mstring` definitions from `ocean.transition`
  module, keeping them available in original module via non-deprecated alias.
  This is done as part of splitting `ocean.transition` into smaller parts and
  thus simplifying dependency chains.

* `ocean.meta.types.Typedef`

  Moved from `ocean.transition.Typedef`. Remains available via
  `ocean.transition` as non-deprecated alias. This is done as part of splitting
  `ocean.transition` into smaller parts and thus simplifying dependency chains.

* `ocean.meta.traits.Basic`

  New `isTypedef` trait is enhanced version of old
  `ocean.core.Traits.isTypedef`, returning enum instead of plain boolean and
  thus allowing to distinguish between typedef keyword case and struct-based
  emulation if that is needed in generic code.