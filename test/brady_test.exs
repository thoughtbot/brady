defmodule BradyTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  alias Plug.Conn
  doctest Brady

  setup do
    Application.put_env(:brady, :otp_app, :brady)
    Application.put_env(:brady, :svg_path, "../../../../test/support/svg")
  end

  describe "picture_tag/1" do
    test "returns a <picture> tag with a placeholder" do
      html =
        [placeholder: "test.png"]
        |> Brady.picture_tag()
        |> Phoenix.HTML.safe_to_string()

      assert html == ~s|<picture><img src="test.png"></picture>|
    end

    test "passes options down to fallback image" do
      html =
        [class: "foo", placeholder: "test.png", id: "bla"]
        |> Brady.picture_tag()
        |> Phoenix.HTML.safe_to_string()

      assert html == ~s|<picture><img class="foo" id="bla" src="test.png"></picture>|
    end

    test "creates source tags for each given source" do
      html =
        [placeholder: "test.png", sources: ["bla.png"]]
        |> Brady.picture_tag()
        |> Phoenix.HTML.safe_to_string()

      assert html == ~s|<picture><source srcset="bla.png"></source><img src="test.png"></picture>|
    end

    test "creates source tags for each given sources" do
      html =
        [placeholder: "test.png", sources: ["bla1.png", "bla2.png"]]
        |> Brady.picture_tag()
        |> Phoenix.HTML.safe_to_string()

      assert html == ~s|<picture><source srcset="bla1.png"></source><source srcset="bla2.png"></source><img src="test.png"></picture>|
    end
  end

  test "body_class returns controller and action" do
    conn = %Conn{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.PageController
      }}

    assert Brady.body_class(conn) == "page page-index"
  end

  test "body_class dasherizes multi-word controller names" do
    conn = %Conn{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.AwesomePageController
      }}

    assert Brady.body_class(conn) == "awesome-page awesome-page-index"
  end

  test "body_class returns namespaced controller and action" do
    conn = %Conn{
      private: %{
        phoenix_action: :index,
        phoenix_controller: Test.More.PageController
      }}

    assert Brady.body_class(conn) == "more-page more-page-index"
  end

  test "returns an empty string if no controller is present" do
    conn = %Conn{private: %{}}

    assert Brady.body_class(conn) == ""
  end

  describe "path" do
    test "it includes the path in the class name" do
      conn = %Conn{
        path_info: ["admin", "user"],
        private: %{
          phoenix_action: :index,
          phoenix_controller: Test.UserController
        }}

      assert Brady.body_class(conn) == "admin-user user user-index"
    end

    test "when the route ends with a number, it is not included" do
      conn = %Conn{
        path_info: ["admin", "user", "1"],
        private: %{
          phoenix_action: :show,
          phoenix_controller: Test.UserController
        }}

      assert Brady.body_class(conn) == "admin-user user user-show"
    end
  end

  describe "inline_svg" do
    test "it renders an html safe version of the SVG" do
     assert Brady.inline_svg("test", class: "foo", "data-role": "bar") == test_svg()
    end

    test "it returns a runtime error if SVG is not found" do
      assert_raise RuntimeError, ~r|No SVG found at|, fn ->
        Brady.inline_svg("non_existant")
      end
      assert_raise RuntimeError, ~r|support/svg/non_existant.svg|, fn ->
        Brady.inline_svg("non_existant")
      end
    end

    defp test_svg do
      {:safe,
       ~s(<svg class="foo" data-role="bar" height="100" width="100"><desc>This is a test svg</desc><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red"></circle></svg>)}
    end
  end

  describe "data_uri/1" do
    test "it returns a base64 encoded string of the given image" do
      image = test_asset_path("test/support/test-small.png")

      result = Brady.data_uri(image)

      assert result == "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg=="
    end

    test "it emits a warning when the file is more than 2kb by default" do
      path = test_asset_path("test/support/test-large.png")

      assert capture_log(fn ->
        Brady.data_uri(path)
      end) =~ """
      Warning: The file "#{path}" is large and not recommended for inlining in templates. Please reconsider inlining this image, or increase the inline threshold by setting:

      config :brady, inline_threshold: size_in_bytes
      """
    end

    test "it does not emit a warning when the file is less than configured inline threshold" do
      Application.put_env(:brady, :inline_threshold, 99999999)
      path = test_asset_path("test/support/test-large.png")

      refute capture_log(fn ->
        Brady.data_uri(path)
      end) =~ """
      Warning: The file "#{path}" is large and not recommended for inlining in templates. Please reconsider inlining this image.
      """

      Application.delete_env(:brady, :inline_threshold)
    end
  end

  defp test_asset_path(path) do
    "../../../../../../#{path}"
  end
end
