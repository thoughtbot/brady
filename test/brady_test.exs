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

  test "body_class with suffix adds suffix to controller name" do
    conn = %Conn{
      private: %{
        phoenix_action: :index,
        phoenix_controller: Test.PostController
      }}

    assert Brady.body_class(conn, suffix: "page") == "post-page post-page-index"
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
end
