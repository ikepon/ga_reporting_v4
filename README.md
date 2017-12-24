# Hisui [![Build Status](https://travis-ci.org/ikepon/hisui.png)](https://travis-ci.org/ikepon/hisui)

Google Analytics Reporting API v4 Client on Rails application

Hisui referred to [Legato](https://github.com/tpitale/legato) which is Google Analytics Reporting API Client for Ruby.

Legato uses Core Reporting API V3.
Hisui uses Reporting API v4.

But, usage is similar to Legato.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'hisui'
```

And then execute:
```bash
$ bundle install
```

## Usage
### Google Analytics Management API Version 3.0
Usage is the same as [Legato](https://github.com/tpitale/legato/blob/master/README.md#google-analytics-management).

### Google Analytics Reporting API v4
1. Get profile.
```ruby
user = Hisui::User.new(access_token)
profile = user.profiles.first # Select profile that you want to get Google Analytics data.
```

2. Create class extended `Hisui::Model`. And Set `metrics` and `dimensions`.
```ruby
class DailySummary
  extend Hisui::Model

  metrics :pageviews, :sessions, :users, :new_users, :bounce_rate, :pageviews_per_session, :avg_session_duration
  dimensions :date
end
```

3. Get Google Analytics API response with `results` methods.
Set `start_date` and `end_date` if you need.(defult period is past one month)
```ruby
response = DailySummary.results(profile: profile, start_date: Date.current - 7.days, end_date: Date.current)
```

4. Use data.
```ruby
response.raw_attributes

#=> [#<OpenStruct date="20171122", pageviews="137", sessions="73", users="51", newUsers="43", bounceRate="69.56521739130434", pageviewsPerSession="2.608695652173913", avgSessionDuration="87.69565217391305">,
# ...
# #<OpenStruct date="20171129", pageviews="95", sessions="67", users="44", newUsers="32", bounceRate="80.0", pageviewsPerSession="2.25", avgSessionDuration="42.0">]

response.total_values

#=> #<OpenStruct pageviews="646", sessions="308", users="223", newUsers="144", bounceRate="77.77777777777779", pageviewsPerSession="2.3518518518518519", avgSessionDuration="62.148148148148145">

response.data?

#=> true
```

## Contributing
Fork it, fix me, and send me your pull requests.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
