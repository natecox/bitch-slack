defmodule BitchSlack.SlapController do
  use BitchSlack.Web, :controller

  def slap(conn, post_params) do
    param_token = Map.get(post_params, "token")
    command = Map.get(post_params, "command")
    response = command_response(command)

    cond do
      token_invalid?(param_token) ->
        conn |> send_resp(500, "Invalid token")
      response ->
        json conn, %{response_type: "in_channel", text: response.text, attachments: response.attachments}
      true ->
        conn |> send_resp(404, "")
    end
  end

  def token_invalid?(token) do
    slack_token = System.get_env("SLACK_TOKEN")

    cond do
      slack_token === token -> false
      true -> true
    end
  end

  def command_response(command) do
    case command do
      "/bitch" ->
        %{text: "If you're a bitch!", attachments: [%{text: ":carlton:"}]}
      _ -> false
    end
  end
end
