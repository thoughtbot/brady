defmodule Brady do
  alias Phoenix.Controller

  @doc """
  Returns the controller name and controller-action name as a lowercase,
  dasherized string.

  For example, when the `conn` came from CoolWidgetsController#show:

      Brady.body_class(conn) => 'cool-widgets cool-widgets-show'"

  """
  @spec body_class(%Plug.Conn{}) :: String.t
  def body_class(conn = %Plug.Conn{private: %{phoenix_controller: _}}) do
    controller_name = format_controller_name(conn)
    "#{format_path(conn)} #{controller_name} #{controller_name}-#{Controller.action_name(conn)}"
    |> String.trim
  end
  def body_class(_) do
    ""
  end

  @doc """
  Embeds an html safe raw SVG in the markup. Also takes an optional list of CSS
  attributes and applies those to the SVG.

  Ex:
      Brady.inline_svg("test", class: "foo", "data-role": "bar") =>
      {:safe,
       "<svg class=\"foo\" data-role=\"bar\" height=\"100\" width=\"100\"><desc>This is a test svg</desc><circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"black\" stroke-width=\"3\" fill=\"red\"></circle></svg>"}
  """
  @spec inline_svg(String.t, keyword) :: String.t
  def inline_svg(file_name, options \\ []) do
    path = static_path(file_name)
    case File.read(path) do
      {:ok, file} -> render_with_options(file, options)
      {:error, _} -> raise "No SVG found at #{path}"
    end
  end

  defp render_with_options(markup, []), do: {:safe, markup}
  defp render_with_options(markup, options) do
    markup
    |> Floki.parse
    |> Floki.find("svg")
    |> add_attributes(options)
    |> Floki.raw_html
    |> render_with_options([])
  end

  defp add_attributes([{tag_name, existing_attributes, contents}], attributes) do
    attributes = Enum.map(attributes, fn{key, value} -> {to_string(key), value} end)
    {tag_name, attributes ++ existing_attributes, contents}
  end

  defp static_path(file_name) do
    path = Application.get_env(:brady, :svg_path) || "web/static/svg"
    Path.join(path, "#{file_name}.svg")
  end

  defp format_path(conn) do
    conn.path_info
    |> remove_numbers
    |> Enum.join("-")
  end

  defp remove_numbers(path_list) do
    Enum.filter path_list, fn (item) ->
      Integer.parse(item) == :error
    end
  end

  defp format_controller_name(conn) do
    conn
    |> Controller.controller_module
    |> to_string
    |> String.split(".")
    |> Enum.slice(2..-1)
    |> Enum.join("")
    |> remove_controller
    |> dasherize
    |> String.downcase
  end

  defp dasherize(name) do
    ~r/(?=[A-Z])/
    |> Regex.split(name)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("-")
  end

  @controller_string_length 10
  defp remove_controller(name)  do
    name
    |> String.slice(0, String.length(name) - @controller_string_length)
  end
end
