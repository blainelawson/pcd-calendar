This is a small change

# Pcd::Calendar

PCD Calendar will scrape event data from the calendar available on pinellasdemocrats.org, giving the user the ability to list events group. Events should be displayed with dates, times, and locations. This Gem should also provide a secondary use of presenting information pertinent to groups, such as address, Facebook page, website, and phone number.

Collecting said information will require four classes: Scraper, which will only be collecting the data from the website; Group, which will instantiate a new group with their details; Events, which will hold each event; and the CLI class, which will be used to interact with the user.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pcd-calendar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pcd-calendar

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/'affable-karma-8454'/pcd-calendar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pcd::Calendar project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/'affable-karma-8454'/pcd-calendar/blob/master/CODE_OF_CONDUCT.md).
