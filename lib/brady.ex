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
    Regex.split(~r/(?=[A-Z])/, name)
    |> Enum.join("-")
  end

  defp remove_controller(name)  do
    name
    |> String.slice(0, String.length(name) - controller_string_length)
  end

  defp  controller_string_length  do
    10
  end
end
