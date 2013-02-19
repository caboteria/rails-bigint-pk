## rails-bigint-pk [![Build Status](https://secure.travis-ci.org/VerticalResponse/rails-bigint-pk.png?branch=master)](https://travis-ci.org/VerticalResponse/rails-bigint-pk)

### Overview

rails-bigint-pk aims to be a simple, transparent way to use 64bit primary keys
in mysql and postgres.

### Requirements

rails-bigint-pk has been tested with rails 3.2.12, which at the time of writing
is the latest patch version for 3.2.  If you use a higher patch version, it is
recommended to run the test suite against your version of rails and activerecord.

### Installation & Usage

* Add the following to your `Gemfile`
  `gem 'rails-bigint-pk', git: 'https://github.com/VerticalResponse/rails-bigint-pk.git'`

* Run the generator
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
git clone git://github.com/VerticalResponse/rails-bigint-pk.git
cd rails-bigint-pk

# edit rails-bigint-pk.gemspec or Gemfile to set the version of activerecord to
# the one you are using

bundle install

# verify that Gemfile.lock's entry for activerecord matches the version you want
to test against.

# This will run integration specs against all supported database types, and
# requires running servers for postgres and mysql.
rake spec
```
