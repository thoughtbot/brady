defmodule BradyTest do
  use ExUnit.Case
  alias Plug.Conn
  doctest Brady

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
    test "it renders an html safe version of the svg" do
     assert Brady.inline_svg("test", class: "foo", "data-role": "bar") == test_svg
    end

    test "it returns a runtime error if svg is not found" do
      message = "No SVG found at test/support/svg/non_existant.svg"
      assert_raise RuntimeError, message, fn ->
        Brady.inline_svg("non_existant")
      end
    end

    def test_svg(options \\ []) do
      {:safe,
       "<svg class=\"foo\" data-role=\"bar\" height=\"100\" width=\"100\"><desc>This is a test svg</desc><circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"black\" stroke-width=\"3\" fill=\"red\"></circle></svg>"}
    end
  end
end
