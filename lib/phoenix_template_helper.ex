defmodule PhoenixTemplateHelper do
  alias Phoenix.Controller

  def body_class(conn) do
    controller_name = format_controller_name(conn)
    "#{controller_name} #{controller_name}-#{Controller.action_name(conn)}"
  end

  defp format_controller_name(conn) do
    conn
    |> Controller.controller_module
    |> to_string
    |> String.split(".")
    |> List.last
    |> String.downcase
    |> remove_controller
  end

  defp remove_controller(name)  do
    name
    |> String.slice(0, String.length(name) - controller_string_length)
  end

  defp  controller_string_length  do
    10
  end
end
