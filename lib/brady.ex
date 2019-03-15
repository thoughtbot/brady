defmodule Brady do
  alias Phoenix.Controller
  require Logger

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

  @spec picture_tag(Keyword.t()) :: Phoenix.HTML.Tag.t()
  def picture_tag(options \\ []) do
    {fallback_src, options} = Keyword.pop(options, :placeholder)
    {sources, options} = Keyword.pop(options, :sources, [])
    fallback_img = Phoenix.HTML.Tag.img_tag(fallback_src, options)
    sources = Enum.map(sources, fn source ->
      Phoenix.HTML.Tag.content_tag(:source, nil, srcset: source)
    end)
    values = [sources | [fallback_img]]

    Phoenix.HTML.Tag.content_tag :picture, [] do
      values
    end
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

  @doc """
  Encodes an image to base64-encoded data uri, compatible for img src attributes. Only recommended
  for files less than 2kb. This threshold is configurable with mix config:

      config :brady, inline_threshold: 10_240

  Ex:
      Brady.data_uri("placeholder.gif")
      # => "data:image/gif;base64,iVBORw0KGgoAAAA"
  """
  def data_uri(path) do
    app_dir = Application.app_dir(Application.get_env(:brady, :otp_app))
    base64 =
      [app_dir, "priv/static", path]
      |> Path.join()
      |> Path.expand()
      |> File.read!()
      |> Base.encode64()
      |> maybe_warn_about_size(path)

    mime = MIME.from_path(path)

    "data:#{mime};base64,#{base64}"
  end

  defp maybe_warn_about_size(base64, path) do
    limit = Application.get_env(:brady, :inline_threshold, 2048)

    if String.length(base64) > limit do
      Logger.warn("""
      Warning: The file "#{path}" is large and not recommended for inlining in templates. Please reconsider inlining this image, or increase the inline threshold by setting:

      config :brady, inline_threshold: size_in_bytes
      """)
    end

    base64
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
    app_dir = Application.app_dir(Application.get_env(:brady, :otp_app))
    path = Application.get_env(:brady, :svg_path) || "priv/static/svg"
    [app_dir, path, "#{file_name}.svg"] |> Path.join() |> Path.expand
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
