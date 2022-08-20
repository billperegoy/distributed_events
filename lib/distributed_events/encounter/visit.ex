defmodule DistributedEvents.Encounter.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  alias DistributedEevents.Encounter

  schema "visits" do
    timestamps()
  end

  def changeset(visit) do
    change(visit)
  end
end
