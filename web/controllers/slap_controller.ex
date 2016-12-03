defmodule SlackMessage do
  @derive [Poison.Encoder]
  defstruct [:response_type, :text, :attachments]
end

defmodule SlackDelayedMessage do
  def post(url, message) do
    HTTPoison.post! url, Poison.encode!(message)
  end
end

defmodule BitchSlack.SlapController do
  use BitchSlack.Web, :controller

  def slap(conn, post_params) do
    param_token = Map.get(post_params, "token")
    command = Map.get(post_params, "command")
    response_url = Map.get(post_params, "response_url")
    username = Map.get(post_params, "user_name")
    message = command_response(command, username)

    cond do
      token_invalid?(param_token) ->
        conn |> send_resp(500, "Invalid token")
      message ->
        SlackDelayedMessage.post(response_url, message)
        conn |> send_resp(200, "")
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

  def command_response(command, username) do
    case command do
      "/bitch" ->
        %SlackMessage{
          response_type: "ephemeral",
          text: "@#{username}: If you're a bitch!",
          attachments: [%{text: ":carlton:"}]
        }
      _ -> false
    end
  end
end
