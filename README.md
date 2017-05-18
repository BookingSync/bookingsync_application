[![Code Climate](https://codeclimate.com/github/BookingSync/bookingsync_application/badges/gpa.svg)](https://codeclimate.com/github/BookingSync/bookingsync_application)
[![Build Status](https://travis-ci.org/BookingSync/bookingsync_application.svg?branch=master)](https://travis-ci.org/BookingSync/bookingsync_application)

# BookingsyncApplication

A Rails engine to simplify building BookingSync Applications.

## Requirements

This engine requires Rails `>= 4.0.0` and Ruby `>= 2.0.0`.

## Documentation

[API documentation is available at rdoc.info](http://www.rubydoc.info/gems/bookingsync_application).

## Installation

BookingSync Application works with Rails 4.0 onwards and Ruby 2.0 onwards. To get started, add it to your Gemfile with:

```ruby
gem 'bookingsync_application'
```

Then bundle install:

```ruby
bundle install
```

### Add authorization routes

Then mount BookingSync Authorization routes inside `routes.rb`:
```ruby
mount BookingSync::Engine => '/'
```

This will add the following routes:

* `/auth/bookingsync/callback`
* `/auth/failure`
* `/signout`

### Add a model to link with BookingSync accounts

BookingSync Application uses the `Account` model to authenticate each BookingSync Account, if you do not have an `Account` model yet, create one:

```console
rails g model Account
```

Then, generate a migration to add OAuth fields for the `Account` class:

```console
rails g migration AddOAuthFieldsToAccounts provider:string synced_id:integer:index \
  name:string oauth_access_token:string oauth_refresh_token:string \
  oauth_expires_at:string
```

and migrate:

```console
rake db:migrate
```

Also include `BookingSync::Engine::Account` in your `Account` model:

```ruby
class Account < ActiveRecord::Base
  include BookingSync::Engine::Model
end
```

### Secure controllers to require a BookingSync authorized account

We now want to provide secured controllers, this controllers will be accessible only to BookingSync identified accounts.

You have 2 options pre built for this:

1) Create base API controller (it will be `json` based):
```
class Api::BaseController < BookingsyncApplication::Api::BaseController
end
```

2) Optionally if you want to have `html` based controller:
```
class Admin::BaseHTMLController < ApplicationController
  respond_to :html

  include BookingsyncApplication::Controllers::CommonBase
end
```


_Note: When saving new token, this gem uses a separate thread with new db connection to ensure token save (in case of a rollback in the main transaction). To make room for the new connections, it is recommended to increase db `pool` size by 2-3._

## Configuration

The engine is configured by the following ENV variables:

* `BOOKINGSYNC_URL` - the url of the website, should be
* `BOOKINGSYNC_APP_ID` - BookingSync Application's Client ID
* `BOOKINGSYNC_APP_SECRET` - BookingSync Application's Client Secret
* `BOOKINGSYNC_VERIFY_SSL` - Verify SSL (available only in development or test). Default to false
* `BOOKINGSYNC_SCOPE` - Space separated list of required scopes. Defaults to nil, which means the public scope.

You might want to use [dotenv-rails](https://github.com/bkeepers/dotenv)
to make ENV variables management easy.

## Testing

### RSpec

We do provide some helper for RSpec users, you can include them in your `spec/rails_helper.rb` (before `spec/support` inclusion):
```
require 'bookingsync_application/spec_helper'
```

### VCR

We recommend a VCR setup inspired from the following configuration. It will mask authorization tokens from your fixtures:

```ruby
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('BOOKINGSYNC_OAUTH_ACCESS_TOKEN') do
    ENV['BOOKINGSYNC_OAUTH_ACCESS_TOKEN']
  end
  # Uncomment if using codeclimate
  # config.ignore_hosts 'codeclimate.com'
end
```
