## rails-bigint-pk

### Overview

rails-bigint-pk aims to be a simple, transparent way to use 64bit primary keys
in mysql and postgres.


### Installation & Usage

* Add the following to your `Gemfile`
  `gem 'rails-bigint-pk', git: 'https://github.com/VerticalResponse/rails-bigint-pk.git'`

* Run the generator
  `rails generate bigint_pk:install`

This will create an initializer that enables 64 bit primary and foreign keys by
changing the default primary key type, and using `limit: 8` for foreign keys
created via `references`.

It will also create a migration to update all existing primary and foreign keys.
