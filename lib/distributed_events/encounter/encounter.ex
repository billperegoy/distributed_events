defmodule DistributedEvents.Encounter do
  alias DistributedEvents.{Encounter, Finance, Repo}
  alias Ecto.Multi
  alias Phoenix.PubSub

  # Step 1 - create a standalone viist
  def create_visit do
    %Encounter.Visit{}
    |> Encounter.Visit.changeset()
    |> Repo.insert()
  end

  # Step 2 - create a safe visit/invoice but with knowledge of the other context
  def create_visit_with_invoice do
    Multi.new()
    |> Multi.insert(:visit, Encounter.Visit.changeset(%Encounter.Visit{}))
    |> Multi.insert(:invoice, fn %{visit: visit} ->
      Finance.Invoice.changeset(%Finance.Invoice{}, %{visit_id: visit.id})
    end)
    |> Repo.transaction()
  end

  # Step 3 - distributed but unsafe (no transaction)
  def create_visit_with_notification do
    %Encounter.Visit{}
    |> Encounter.Visit.changeset()
    |> Repo.insert()
    |> case do
      {:ok, visit} ->
        PubSub.broadcast(DistributedEvents.PubSub, "visits", {:visit_created, %{id: visit.id}})
        {:ok, visit}

      error ->
        error
    end
  end

  #
  # Step 4 - distributed with transaction
  def create_visit_with_notification_and_transaction do
    multi = Multi.insert(Multi.new(), :visit, Encounter.Visit.changeset(%Encounter.Visit{}))

    PubSub.broadcast(DistributedEvents.PubSub, "visits", {:visit_created2, multi})
  end
end
