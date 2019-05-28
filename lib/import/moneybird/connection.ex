defmodule Debiteurenbeheer.Import.Moneybird.Connection do
  @behaviour Debiteurenbeheer.Import.Connection
  alias Debiteurenbeheer.Import.Moneybird

  def outstanding_invoices do
    invoices = Moneybird.Invoices.list()
    contact_ids = get_unique_contact_ids(invoices)

    contacts = Moneybird.Debtors.fetch_debtors_by_ids(contact_ids)
    merge_invoices_and_contacts(invoices, contacts)
  end

  defp get_unique_contact_ids(invoices) do
    Enum.map(invoices, fn invoice -> invoice["contact_id"] end)
    |> Enum.uniq()
  end

  defp merge_invoices_and_contacts(invoices, contacts) do
    Enum.map(invoices, fn invoice ->
      invoice_contact =
        Enum.find(contacts, fn contact -> contact["id"] == invoice["contact_id"] end)

      Map.merge(invoice, %{debtor: invoice_contact})
    end)
  end
end
