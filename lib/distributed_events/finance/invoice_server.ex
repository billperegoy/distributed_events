defmodule DistributedEvents.Finance.InvoiceServer do
  use GenServer

  alias DistributedEvents.{Finance, Repo}
  alias Ecto.Multi

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Phoenix.PubSub.subscribe(DistributedEvents.PubSub, "visits")
    {:ok, %{}}
  end

  def handle_info({:visit_created, %{id: visit_id}}, state) do
    IO.puts("Received visit created for id: #{visit_id}")

    %Finance.Invoice{}
    |> Finance.Invoice.changeset(%{visit_id: visit_id})
    |> Repo.insert()

    {:noreply, state}
  end

  def handle_info({:visit_created2, multi}, state) do
    IO.puts("Received visit_created multi")

    multi
    |> Multi.insert(:invoice, fn
      %{visit: visit} ->
        Finance.Invoice.changeset(%Finance.Invoice{}, %{visit_id: visit.id})
    end)
    |> Repo.transaction()

    {:noreply, state}
  end
end
