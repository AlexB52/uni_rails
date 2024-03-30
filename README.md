# UniRails

This library allows you to create rails apps within a single ruby file. This is useful for small personal CRUD apps or for education. This library helps writers to develop simple Gists alongside articles or books to illustrate the concept they aim to teach. There is often no point in initializing a full rails structure to explain simple ideas, and the library allows users to copy a ruby file and have a working rails app where all the components are located in a single file.

Ruby on Rails can now have single-file apps.


## Roadmap

Current railties and engine supported. Please help us support more of them

- [X] action_controller
- [X] active_record
- [ ] active_model/railtie
- [ ] active_job/railtie
- [ ] active_storage/engine
- [ ] action_mailer/railtie
- [ ] action_mailbox/engine
- [ ] action_text/engine
- [ ] action_view/railtie
- [ ] action_cable/engine


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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UniRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/uni_rails/blob/main/CODE_OF_CONDUCT.md).
