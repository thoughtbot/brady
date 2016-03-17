# PhoenixTemplateHelper

PhoenixTemplateHelper provides helper functions for use within Phoenix templates.

## Usage

### Installation

Add phoenix_template_helper to your list of dependencies in `mix.exs`:

```
        def deps do
          [{:phoenix_template_helper, "~> 0.0.1"}]
        end
```

### Body Class

The body_class method can be used like:

`body class="<%= PhoenixTemplateHelper.body_class @conn%>"`

This will produce a string including the controller name and controller-action
name. For example, The WidgetsController#show action would produce:

`widgets widgets-show`

## Contributing

See the [CONTRIBUTING] document.
Thank you, [contributors]!

  [CONTRIBUTING]: CONTRIBUTING.md
  [contributors]: https://github.com/thoughtbot/phoenix_template_helper/graphs/contributors

## License

PhoenixTemplateHelper is Copyright (c) 2015 thoughtbot, inc.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

  [LICENSE]: /LICENSE

## About

![thoughtbot](https://thoughtbot.com/logo.png)

PhoenixTemplateHelper is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community]
or [hire us][hire] to help build your product.

  [community]: https://thoughtbot.com/community?utm_source=github
  [hire]: https://thoughtbot.com/hire-us?utm_source=github
