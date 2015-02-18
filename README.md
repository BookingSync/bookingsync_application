# bookingsync-application-engine

A Rails engine to simplify building BookingSync Applications.

# Usage

* add lines to Gemfile (they need to be side-required):
```
gem 'bookingsync-engine'
gem 'bookingsync-application-engine'
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
