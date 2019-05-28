defmodule Debiteurenbeheer.Import.Debtor do
  @derive [Poison.Encoder]

  defstruct [
    :debtor_code,
    :id,
    :name
  ]
end
