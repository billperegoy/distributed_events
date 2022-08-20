defmodule DistributedEvents.Repo do
  use Ecto.Repo,
    otp_app: :distributed_events,
    adapter: Ecto.Adapters.Postgres
end
