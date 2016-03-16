defmodule PhoenixTemplateHelperTest do
  use ExUnit.Case
  doctest PhoenixTemplateHelper

  test "body_class returns controller and action" do
    conn = %{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.PageController
      }}

    assert PhoenixTemplateHelper.body_class(conn) == "page page-index"
  end

  test "body_class dasherizes multi-word controller names" do
    conn = %{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.AwesomePageController
      }}

    assert PhoenixTemplateHelper.body_class(conn) == "awesome-page awesome-page-index"
  end
end
