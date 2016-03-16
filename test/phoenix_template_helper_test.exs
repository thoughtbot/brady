defmodule PhoenixTemplateHelperTest do
  use ExUnit.Case
  doctest PhoenixTemplateHelper

  test "body_class" do
    conn = %{
      private: %{
        :phoenix_action => :index,
        :phoenix_controller => Test.PageController
      }}

    assert PhoenixTemplateHelper.body_class(conn) == "page page-index"
  end
end
