defmodule Debiteurenbeheer.Import.Connection do
  @callback outstanding_invoices() :: {:ok, term}
  @callback debtors() :: {:ok, term} | {:error, String.t()}
end
