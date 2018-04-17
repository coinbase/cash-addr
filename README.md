# CashAddr

Utility to convert between base58 and CashAddr BCH addresses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cash-addr'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install cash-addr
```

## Usage

To convert from a legacy address to CashAddr:

```
CashAddr::Converter.to_cash_address('mmRH4e9WW4ekZUP5HvBScfUyaSUjfQRyvD')
```

To convert from a CashAddr address to legacy:

```
CashAddr::Converter.to_legacy_address('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf')
```

To validate a BCH address:

```
CashAddr::Converter.is_valid?('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf')
```

To display a BCH CashAddr address without the prefix:

```
CashAddr::Converter.display_address('bchtest:qpqtmmfpw79thzq5z7s0spcd87uhn6d34uqqem83hf')
```

NOTE: Testnet addresses are used as examples, but both testnet and mainnet are supported.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Documentation

Docs are generated via rdoc and are located in the `doc` directory. To update the documentation:

```
rdoc --main README.md -x Gemfile -x Rakefile -x setup -x address -x crypto
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coinbase/cash-addr.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
