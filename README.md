# Brady

**Brady is part of the [thoughtbot Elixir family][elixir-phoenix] of projects.**

Brady provides helper functions for use within Phoenix templates.

## Usage

### Installation

Add brady to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [
      {:brady, "~> 0.0.7"},
    ]
  end
```

And configure it in `config.exs`:

```elixir
  config :brady, otp_app: :my_app
```

### Body Class

The body_class function can be used like:

`body class="<%= Brady.body_class @conn %>"`

This will produce a string including the controller name and controller-action
name. For example, The WidgetsController#show action would produce:

`widgets widgets-show`

### Data URI

To inline an image, you may use the `Brady.data_uri/1` function. Pass in the
path relative to `priv/static` and Brady will read the file, base64 encode it, and
return the data uri that is compatible to use within an `<img>` tag.

For example:

`<%= img_tag(Brady.data_uri("images/placeholder.gif"), alt: "Celery Man" %>`

It's not recommended to inline images that are more than a few kilobytes in
size. By default, Brady will emit a warning when inlining an image more than
2kb. You can configure this yourself with Mix config:

```elixir
  config :brady,
    otp_app: :my_app,
    inline_threshold: 10_240
```

### Inline SVG

The inline_svg function works by passing in your SVG file name and, optionally,
any CSS attributes you'd like to apply to the SVG.

`<%= Brady.inline_svg("foo", class: "bar") %>`

This will embed the html safe raw SVG in your markup.

`{:safe, ~s(<svg class="foo" data-role="bar" height="100" width="100"><desc>This is a test svg</desc><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red"></circle></svg>)}`

By default, it looks for files in `priv/static/svg/#{file_name}.svg` but you can
configure this in your config.exs

```elixir
  config :brady,
    otp_app: :my_app,
    svg_path: "web/static/images"
```

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

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

Brady is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software, Elixir, and Phoenix. See [our other Elixir
projects][elixir-phoenix], or [hire our Elixir Phoenix development team][hire]
to design, develop, and grow your product.

  [elixir-phoenix]: https://thoughtbot.com/services/elixir-phoenix?utm_source=github
  [hire]: https://thoughtbot.com?utm_source=github
