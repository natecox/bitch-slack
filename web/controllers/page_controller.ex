defmodule BitchSlack.PageController do
  use BitchSlack.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
