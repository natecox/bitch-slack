defmodule SlackMessage do
  @derive [Poison.Encoder]
  defstruct [:response_type, :text, :attachments]
end

defmodule SlapUtils do
  def post_delayed_message(params) do
    params
    |> validate_token
    |> get_response_message
    |> send_message
  end

  def slack_token(), do: System.get_env("SLACK_TOKEN")

  defp validate_token(params) do
    validate_token(params, slack_token())
  end

  defp validate_token(%{token: token} = params, system_token)
  when token == system_token do
    Map.put(params, :authenticated, true)
  end

  defp validate_token(params, _system_token) do
    Map.put(params, :authenticated, false)
  end

  def send_message(%{authenticated: authenticated}) when not authenticated do
    %{message: "Invalid token", code: 500}
  end

  def send_message(%{message: message}) when not message do
    %{message: "", code: 404}
  end
  
  def send_message(params) do
    HTTPoison.post! params.url, Poison.encode!(params.message)
    %{message: "", code: 200}
  end

  def get_response_message(params) do
    Map.put(params, :message, command_response(params.command, params.username))
  end

  def command_response("/bitch", username) do
    %SlackMessage{
      response_type: "in_channel",
      text: "@#{username}: If you're a bitch!",
      attachments: [%{text: ":carlton:"}]
    }
  end

  def command_response(_command, _username) do
    nil
  end

end

defmodule BitchSlack.SlapController do
  use BitchSlack.Web, :controller

  def slap(conn, post_params) do
    param_token = Map.get(post_params, "token")
    response_url = Map.get(post_params, "response_url")
    command = Map.get(post_params, "command")
    username = Map.get(post_params, "user_name")

    response = SlapUtils.post_delayed_message(
      %{:token    => param_token,
        :url      => response_url,
        :command  => command,
        :username => username})

    conn |> send_resp(response.code, response.message)
  end

end
