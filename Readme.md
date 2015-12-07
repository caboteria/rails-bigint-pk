## rails-bigint-pk [![Build Status](https://secure.travis-ci.org/caboteria/rails-bigint-pk.png?branch=master)](https://travis-ci.org/caboteria/rails-bigint-pk)

### Overview

rails-bigint-pk is a simple, transparent way to use 64bit primary keys
in MySQL and PostgreSQL.

### Requirements

rails-bigint-pk has been tested with rails 4.2.5, which at the time of writing
is the latest patch version for 4.2.  If you use a higher patch version, we
recommend that you run the test suite against your version of rails and activerecord.

### Installation & Usage

#### Rails 4

rails-bigint-pk supports Rails 4.2, 4.1, and 4.0. To install, you can either
download releases from Rubygems by adding the following to your
`Gemfile`:

  `gem 'rails-bigint-pk', '~>1.2.0'`

... or, if you enjoy being on the bleeding edge, you can install the newest code directly from git:

  `gem 'rails-bigint-pk', github: 'caboteria/rails-bigint-pk'`

Then run the generator:
  `rails generate bigint_pk:install`

This will create an initializer that enables 64 bit primary and foreign keys by
changing the default primary key type, and using `limit: 8` for foreign keys
created via `references`.

It will also create a migration to update all existing primary and foreign keys.

#### Rails 3

There is a `rails3` branch for support of 3.2.x versions of Rails.  To
install, you can either download 0.0.x releases from Rubygems by
adding the following to your `Gemfile`:

  `gem 'rails-bigint-pk', '~>0.0.1'`

... or you can install the newest rails3 branch code directly from
git:

  `gem 'rails-bigint-pk', github: 'caboteria/rails-bigint-pk', branch: 'rails3'`

Then run the generator:
  `rails generate bigint_pk:install`

This will create an initializer that enables 64 bit primary and foreign keys by
changing the default primary key type, and using `limit: 8` for foreign keys
created via `references`.

It will also create a migration to update all existing primary and foreign keys.

### Gotchas

When adding foreign key columns, be sure to use `references` and not
`add_column`.

```ruby
change_table :my_table do |t|
  t.references :other_table
end

# Doing this will not use 64bit ints
add_column :my_table, :other_table_id, :int
```

### Running Tests Against Later Versions of Rails

```bash
git clone git://github.com/caboteria/rails-bigint-pk.git
cd rails-bigint-pk

# edit spec/fixtures/Gemfile to set the version of activerecord to
# the one you are using

# purge the test fixture
rm -rf tmp/test\_rails\_app

# This will run integration specs against all supported database types, and
# requires running servers for postgres and mysql.
bundle exec rake spec

# verify that tmp/test_rails_app/Gemfile.lock's entry for activerecord
# matches the version you wanted to test against.

```
