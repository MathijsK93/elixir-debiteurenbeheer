defmodule Debiteurenbeheer.Import.Moneybird.Debtors do
  @moduledoc """
  Functions for fetching debtors from Moneybird administration
  """
  alias Debiteurenbeheer.Import.Moneybird.Client, as: Client

  @api_key "0bde74e1dc5a3c6627d55228c1d4fb0faa531de64f6f1f35fd7586883932b3f2"

  def headers do
    [Authorization: "Bearer #{@api_key}", "Content-Type": "application/json"]
  end

  def fetch_debtors_by_ids(ids) do
    body =
      %{ids: ids}
      |> Poison.encode!()

    response = Client.post!("/contacts/synchronization", body, headers())
    response.body
  end
end
