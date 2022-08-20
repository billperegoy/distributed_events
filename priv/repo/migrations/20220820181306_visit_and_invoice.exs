defmodule Instinct.Repo.Migrations.VisitAndInvoice do
  use Ecto.Migration

  def change do
    create table(:visits) do
      timestamps()
    end

    create table(:invoices) do
      add :visit_id, references(:visits)
      timestamps()
    end
  end
end
