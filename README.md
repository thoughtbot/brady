# PhoenixTemplateHelper

## Installation

Add phoenix_template_helper to your list of dependencies in `mix.exs`:

```
        def deps do
          [{:phoenix_template_helper, "~> 0.0.1"}]
        end
```

## Body Class

The body_class method can be used like:

`body class="<%= PhoenixTemplateHelper.body_class @conn%>"`

This will produce a string including the controller name and controller-action
name. For example, The WidgetsController#show action would produce:

`widgets widgets-show`
