SpreeSales
=============

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spree_sales'
```

And then execute:

```ruby
bundle install
```


And finally run the install generator to automatically insert 'require spree/frontend/spree_minicart' in your asset file. If you experience a problem with loading assets from the 'vendor/assets' folder, simply copy the relevant lines into the 'app/assets' files (all.js, all.css).

```ruby
rails g spree_sales:install
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/spree_sales.

