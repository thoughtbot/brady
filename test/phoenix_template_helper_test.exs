defmodule BradyTest do
  use ExUnit.Case
  doctest Brady

  test "body_class returns controller and action" do
    conn = %{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.PageController
      }}

    assert Brady.body_class(conn) == "page page-index"
  end

  test "body_class dasherizes multi-word controller names" do
    conn = %{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.AwesomePageController
      }}

    assert Brady.body_class(conn) == "awesome-page awesome-page-index"
  end
end
