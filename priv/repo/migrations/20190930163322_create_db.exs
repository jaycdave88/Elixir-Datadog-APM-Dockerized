defmodule UeberauthExample.Repo.Migrations.CreateDb do
  use Ecto.Migration

  def up do
  	create table("ueberauth_example_dev") do
      add :city,    :string, size: 40
      add :temp_lo, :integer
      add :temp_hi, :integer
      add :prcp,    :float

      timestamps()
    end
  end

  def down do
    drop table("ueberauth_example_dev")
  end
end