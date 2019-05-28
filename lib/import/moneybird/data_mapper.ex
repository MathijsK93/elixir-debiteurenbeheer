defmodule Debiteurenbeheer.Import.Moneybird.DataMapper do
  alias Debiteurenbeheer.Import.{Invoice, Debtor}

  def process(invoice) do
    debtor = invoice[:debtor]

    %Invoice{
      id: invoice["id"],
      invoice_date: Date.from_iso8601!(invoice["invoice_date"]),
      due_date: Date.from_iso8601!(invoice["due_date"]),
      currency_code: invoice["currency"],
      amount_total: %Money{amount: invoice["total_price_incl_tax"], currency: invoice["currency"]},
      amount_open: %Money{amount: invoice["total_unpaid"], currency: invoice["currency"]},
      payment_condition: invoice["workflow_id"],
      number: invoice["invoice_id"],
      debtor: %Debtor{
        id: debtor["id"],
        name: "#{debtor["firstname"]} #{debtor["lastname"]}",
        debtor_code: debtor["customer_id"]
      }
    }
  end
end
