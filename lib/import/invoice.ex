defmodule Debiteurenbeheer.Import.Invoice do
  @derive [Poison.Encoder]

  defstruct [
    :amount_open,
    :amount_total,
    :currency_code,
    :debtor,
    :due_date,
    :id,
    :invoice_date,
    :number,
    :payment_condition
  ]
end
