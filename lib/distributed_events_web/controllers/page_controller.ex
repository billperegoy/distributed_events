defmodule DistributedEventsWeb.PageController do
  use DistributedEventsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
