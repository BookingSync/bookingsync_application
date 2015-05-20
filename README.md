[![Code Climate](https://codeclimate.com/github/BookingSync/bookingsync_application/badges/gpa.svg)](https://codeclimate.com/github/BookingSync/bookingsync_application)
[![Build Status](https://travis-ci.org/BookingSync/bookingsync_application.svg?branch=master)](https://travis-ci.org/BookingSync/bookingsync_application)

# BookingsyncApplication

A Rails engine to simplify building BookingSync Applications.

# Usage

* add bookingsync_application to your gemfile
```
gem 'bookingsync_application'
```
* add to rails_helper (before spec/support inclusion):
```
require 'bookingsync_application/spec_helper'
```
* create base admin controller (it will be json based):
```
class Admin::BaseController < BookingsyncApplication::Admin::BaseController
end
```
* optionally if you want to have html based controller:
```
class Admin::BaseHTMLController < ApplicationController
  respond_to :html

  include BookingsyncApplication::CommonBaseController
end
```
* BookingsyncEngine is a dependency here. Follow steps in https://github.com/BookingSync/bookingsync-engine
