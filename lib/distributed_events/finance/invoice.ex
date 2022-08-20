defmodule DistributedEvents.Finance.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias DistributedEvents.Encounter

  schema "invoices" do
    belongs_to :visit, Encounter.Visit
    timestamps()
  end

  def changeset(invoice, attrs) do
    cast(invoice, attrs, [:visit_id])
  end
end
