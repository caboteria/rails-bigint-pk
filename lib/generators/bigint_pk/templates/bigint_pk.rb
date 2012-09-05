require 'bigint_pk'

BigintPk.setup do |config|
  # Remove this line or set config.enabled to false to prevent future migrations
  # from defaulting to 64bit ints.  This does not affect the initial migration
  # created during installation.
  #
  config.enabled = true
end
