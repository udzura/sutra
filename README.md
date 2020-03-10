# Sutra

[![Gem Version](https://badge.fury.io/rb/sutra.svg)](https://badge.fury.io/rb/sutra)

"Zen as code". Sutra provides `sutra(1)` command, which can manage [Zendesk](https://www.zendesk.com/) resources via Ruby DSL or YAML files.

## Installation

Globally:

    $ gem install sutra

Or add your project Gemfile the line `gem "sutra"` and then run `bundle install`.

## Usage

Setup config file in `~/.sutra/config.toml`:

```toml
[zendesk]
url = "https://your-service.zendesk.com/api/v2"
username = "who@has.api.priv.example.ecom
token = "XXXXXXyyyyyyyyyyyyyy..."

log_file = "/tmp/debug.log"
```

Then run subcommands:

### `sutra macro`

* 2 actions available:

#### `sutra macro dump`

* Dump current macros as YAML into STDOUT/file. `-c` to specify category!

```yaml
$ bundle exec sutra macro dump -c XX.TestGroup
---
- title: XX.TestGroup::TestMacro
  active: true
  position: 1303
  description: |
    This is test
    Yey!
  actions:
  - field: subject
    value: Example
  - field: comment_value
    value: Example
  restriction:
    type: Group
    id: 999999
    name: XX.Testing
```

#### `sutra macro categories`

* Show existing category names.

```
$ bundle exec sutra macro categories -f '^XX'
Available categories:
        XX.TestGroup
```

### else

* TBA! P/Rs are welcomed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/udzura/sutra.
