defmodule BitchSlack.SlapController do
  use BitchSlack.Web, :controller

  def slap(conn, post_params) do
    param_token = Map.get(post_params, "token")
    command = Map.get(post_params, "command")
    response = command_response(command)

    cond do
      token_invalid?(param_token) ->
        conn |> send_resp(500, param_token)
      response ->
        text conn, response
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
      "/bitch" -> "If you're a bitch!"
      _ -> false
    end
  end
end
