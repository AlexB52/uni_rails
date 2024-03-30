# UniRails

UniRails is designed to streamline the process of creating Ruby on Rails applications within a single Ruby file. This approach is ideal for small personal CRUD (Create, Read, Update, Delete) applications or educational purposes, offering a simplified method for demonstrating Rails concepts.

Our goal is to facilitate educators and writers in crafting concise, illustrative examples for articles or books. Traditional Rails applications require a complex structure even for demonstrating basic concepts, which can be cumbersome and unnecessary. Our library addresses this issue by enabling the quick replication of a Ruby file to instantiate a fully operational Rails app, consolidating all essential components into one file.

Embrace the convenience of single-file Rails applications with our library, where simplicity meets functionality.

## Installation & Usage

See some examples of how the UniRails library can be used

-  [json api](/examples/json_api.rb)
-  [todo app](/examples/todos.rb)
-  [hotwire](/examples/hotwire.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/uni_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/uni_rails/blob/main/CODE_OF_CONDUCT.md).

### Roadmap

We would like to support all railties and engines. Please help us support more of them

- [X] action_controller
- [X] active_record
- [X] active_model/railtie
- [ ] active_job/railtie
- [ ] active_storage/engine
- [ ] action_mailer/railtie
- [ ] action_mailbox/engine
- [ ] action_text/engine
- [ ] action_view/railtie
- [ ] action_cable/engine


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UniRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/uni_rails/blob/main/CODE_OF_CONDUCT.md).
