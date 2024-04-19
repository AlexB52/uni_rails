# UniRails

UniRails makes it easy to build Ruby on Rails apps all within one Ruby file. It's perfect for small personal projects or teaching, as everything is one scroll away.

We aim to help educators and writers create clear examples for articles or books. Rails requires a full folder structure to show the basics, which can be a hassle. UniRails cuts through that by letting you spin up a complete Rails app from just one Ruby file — everything you need in one place.

Check out our [examples](/examples) to understand how the library creates Rails apps from a single file.

## Installation & Usage

See some examples of how the UniRails library can be used

-  [Hello world](/examples/hello-world.rb)
-  [Todos app (JSON API)](/examples/todos-api.rb)
-  [Todos app (Rails scaffold)](/examples/todos-scaffold.rb) based off `bin/rails g scaffold todo name completed_at:datetime`
-  [Todos app (Hotwire)](/examples/todos-hotwire.rb) based off online article: [turbo-rails-101-todo-list](https://www.colby.so/posts/turbo-rails-101-todo-list) by David Colby
-  [App using StimulusJS](/examples/stimulus-app.rb) 
-  [App using Puma server](/examples/server-puma-app.rb) 
-  [App using Falcon server](/examples/server-falcon-app.rb)

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
