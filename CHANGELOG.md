# master

* BREAKING: bump bookingsync-engine to ~> 4.0.0
* BREAKING: drop support for ruby prior to 2.3

# 2.0.2 - 2018-11-04

* Add support for Rails 5.2

# 2.0.1 - 2017-11-30

* update bookingsync-engine gem to ~> 3.0.2

# 2.0.0 - 2017-06-21

* Add support for Rails 5.1
* Drop support for Rails prior to 5.0

# 1.0.0

* bump bookingsync-engine to ~> 2.0.1
* drop rails 4.1 support
* Add support for BookingSync Universe API concept
* BREAKING: renamed `BookingsyncApplication::Admin::CommonBaseController` to `BookingsyncApplication::Controllers::CommonBase`

# 0.5.0

* Add support for Rails 5

# 0.4.1

* Add base controller for handling BookingSync's webhooks

# 0.4.0

* Relax synced gem dependency
* Drop ruby 2.0 support, nearing end of life

# 0.3.1

* Update `bookingsync-engine` to ~> 1.0.1

# 0.3.0

* BREAKING CHANGE: Rename account `synced_key` from `uid` to `synced_id`
* bump `bookingsync-engine` to ~> 1.0.0

# 0.2.3

* Relax `jsonapi-resources` version requirement

# 0.2.2

* bump synced to ~> 1.1.1

# 0.2.1

* bump synced dependency to ~> 1.1.0

# 0.2.0

* Remove testing gems
* Update readme
* Update dependencies (jsonapi-resources and synced)

# 0.1.7

* relax rails dependency to ~> 4.0

# 0.1.6

* bump bookingsync-engine, fixes token refresh issues

# 0.1.5

* added admin namespace to common_base_controller
* removed unused stuff, that was causing some dependencies problems in sidekiq

# 0.1.4

* bumped jsonapi resources to 0.0.16
* added rubocop and initial cleanup

# 0.1.3

* require dotenv-rails and not dotenv

# 0.1.2

* update readme to pull dotenv from master to fix bug in loading .env
* require bookingsync_application/common_base_controller to be available in the app

# 0.1.1

* Depend and require synced and dotenv gems

# 0.1.0

* First public versioned release.
