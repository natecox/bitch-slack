defmodule BitchSlack.SlapControllerTest do
  use ExUnit.Case, async: false
  use Plug.Test

  setup do
    System.put_env("SLACK_TOKEN", "12345")

    on_exit fn ->
      System.delete_env("SLACK_TOKEN")
    end
  end

  test "/slap returns 200 with a valid api key" do
    response = conn(:post, "/slap", %{
      command: "/bitch",
      response_url: "localhost:4000",
      token: "12345"
    })
    |> send_request

    assert response.status == 200
  end

  test "/slap returns 500 without a valid api key" do
    response = conn(:post, "/slap", %{command: "/bitch", token: "nope"})
    |> send_request

    assert response.status == 500
    assert response.resp_body == "Invalid token"
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> BitchSlack.Endpoint.call([])
  end
end
