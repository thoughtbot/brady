# Brady

**Brady is part of the [thoughtbot Elixir family][elixir-phoenix] of projects.**

Brady provides helper functions for use within Phoenix templates.

## Usage

### Installation

Add brady to your list of dependencies in `mix.exs`:

```
        def deps do
          [
            {:brady, "~> 0.0.2"},
          ]
        end
```

### Body Class

The body_class function can be used like:

`body class="<%= Brady.body_class @conn %>"`

This will produce a string including the controller name and controller-action
name. For example, The WidgetsController#show action would produce:

`widgets widgets-show`

## Contributing

See the [CONTRIBUTING] document.
Thank you, [contributors]!

  [CONTRIBUTING]: CONTRIBUTING.md
  [contributors]: https://github.com/thoughtbot/brady/graphs/contributors

## License

Brady is Copyright (c) 2015 thoughtbot, inc.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

  [LICENSE]: /LICENSE

## About

![thoughtbot](https://thoughtbot.com/logo.png)

Brady is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software, Elixir, and Phoenix. See [our other Elixir
projects][elixir-phoenix], or [hire our Elixir Phoenix development team][hire]
to design, develop, and grow your product.

  [elixir-phoenix]: https://thoughtbot.com/services/elixir-phoenix?utm_source=github
  [hire]: https://thoughtbot.com?utm_source=github
