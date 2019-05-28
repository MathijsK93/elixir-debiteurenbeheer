defmodule Debiteurenbeheer do
  def hello do
    :world
  end

  def start_import do
    invoices = Debiteurenbeheer.Import.Moneybird.Connection.outstanding_invoices()

    invoices
    # |> group_by_debtor
    |> transform_to_datamapper
    |> write_to_file
  end

  # defp group_by_debtor(invoices) do
  #   invoices
  #   |> Enum.group_by(&Map.fetch(&1, "contact_id"))
  # end

  defp transform_to_datamapper(invoices) do
    Enum.map(invoices, fn invoice ->
      Task.async(Debiteurenbeheer.Import.Moneybird.DataMapper, :process, [invoice])
    end)
    |> Enum.map(fn task -> Task.await(task) end)
  end

  defp write_to_file(data) do
    IO.inspect(data)
    encoded_data = Poison.encode!(data)
    File.write("./import.json", encoded_data, [:binary])
  end
end
