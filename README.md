# ☯️ InnerPerformance [![Gem Version](https://badge.fury.io/rb/inner_performance.svg)](https://badge.fury.io/rb/inner_performance)
Simple database-backed performance monitoring for your Rails app.

<img width="1188" alt="image" src="https://github.com/user-attachments/assets/cb659c76-8139-4ee0-b683-d6acef227dc6">
<img width="1239" alt="image" src="https://github.com/user-attachments/assets/3d15f993-4575-4a5c-977c-5983d3af13c9" />

## Installation
Add `inner_performance` gem to your bundle

```ruby
$ bundle add inner_performance
```

Install migrations

```ruby
$ rails inner_performance:install:migrations
$ rails db:migrate
```

Mount UI in `routes.rb` (don't forget to protect it!)

```ruby
mount InnerPerformance::Engine, at: '/inner_performance'
```

## Configuration

inner_performance comes with some good defaults but in order to customize
them, you have a following options available:

```ruby
InnerPerformance.configure do |config|
  config.sample_rates = {
    # 2% of all the requests will be stored and analyzed. I would
    # recommend keeping it low because otherwise your database will
    # get full of events quite fast. It will also probably impact
    # your app's performance. As an example: In a Spree shop with
    # approx. 170 requests per minute, keeping it at default 2%
    # provides me more than enough data to analyze and locate the
    # bottlenecks. Value can be both decimal and integer.
    'process_action.action_controller' => (Rails.env.production? ? 2 : 100),

    # 100% of all the jobs will be stored and analyzed.
    'perform.active_job' => 100
  }

  # For how long events should be stored. All the ones that exceeds
  # this limit will be cleared out by InnerPerformance::CleanupJob.
  config.events_retention = 1.week

  # Used mostly by UI. Tells the UI what's the middle range when it
  # comes to event duration. For the example below, all the durations
  # between 0 and 200ms will be considered fast, all the ones between
  # 200ms and 999ms will be considered medium and all above 999ms will
  # be considered slow.
  config.medium_duration_range = [200, 999]

  # Set it to true to enable tracing of SQL queries and views rendering
  config.traces_enabled = false

  # Rules for ignoring an event. There are two rules applied by default:
  # * sample_rates - operates on configured sample rate and drops events
  #   which do not got lucky when drawing a random number
  # * InnerPerformance job namespace - we don't want to save events for
  #   the job that saves the events because that leeds to infinite loop.
  #   Better not remove this rule as it will lead to stack overflow.
  config.ignore_rules.unshift(
    proc { |event| !event.is_a?(ActiveSupport::Notifications::Event) }
  )

  # Set it to true if you want to cleanup old events right after saving the event
  config.cleanup_immediately = false
end
```

## Using a separate database
By default, inner_performance stores its data in your application's primary
database. If you'd rather keep it isolated from your primary database (same
idea as `solid_queue`, `solid_cache` or `solid_cable`), you can have it
connect to its own database instead.

First, add the database to `config/database.yml`. If you're using SQLite,
it'll look like this:

```yaml
production:
  primary:
    <<: *default
    database: storage/production.sqlite3
  inner_performance:
    <<: *default
    database: storage/production_inner_performance.sqlite3
    migrations_paths: db/inner_performance_migrate
```

...or if you're using MySQL/PostgreSQL/Trilogy:

```yaml
production:
  primary: &primary_production
    <<: *default
    database: app_production
    username: app
    password: <%= ENV["APP_DATABASE_PASSWORD"] %>
  inner_performance:
    <<: *primary_production
    database: app_production_inner_performance
    migrations_paths: db/inner_performance_migrate
```

Then tell InnerPerformance to connect to it:

```ruby
InnerPerformance.configure do |config|
  config.connects_to = { database: { writing: :inner_performance, reading: :inner_performance } }
end
```

Instead of the regular `inner_performance:install:migrations` task, copy the
migrations into the dedicated path so they only ever run against the
`inner_performance` database:

```
$ rails railties:install:migrations FROM=inner_performance DATABASE=inner_performance
$ rails db:migrate
```

**Note**: to use a separate database outside of production (development,
test, etc.), repeat the `database.yml` entry and `config.connects_to` setup
for those environments too.

## Regular Housekeeping
To ensure optimal performance and avoid data bloat, remember to schedule the cleanup job:

```ruby
InnerPerformance::CleanupJob.perform_later
```

Alternatively to scheduling the job yourself, you may utilize the configuration option `config.cleanup_immediately = true`. This configuration is not as optimal so its disabled by default.

# Alternatives

* [rails_performance](https://github.com/igorkasyanchuk/rails_performance) - much
more robust but depends on Redis. Operates on `ActiveSupport::LogSubscriber`
instead of `ActiveSupport::Notifications`

## License
The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
