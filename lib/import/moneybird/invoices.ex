defmodule Debiteurenbeheer.Import.Moneybird.Invoices do
  @moduledoc """
  Functions for fetching invoices from Moneybird administration
  """
  alias Debiteurenbeheer.Import.Moneybird.Client
  alias Debiteurenbeheer.Import.Invoice

  @api_key "0bde74e1dc5a3c6627d55228c1d4fb0faa531de64f6f1f35fd7586883932b3f2"

  def headers do
    [
      Authorization: "Bearer #{@api_key}",
      "Content-Type": "application/json"
    ]
  end

  def find(%Invoice{id: identifier}) do
    Client.get("/sales_invoices/#{identifier}")
  end

  @doc """
  Fetch invoice by id

  ##  Parameters

    - id: Integer that represents the UUID in Moneybird
  """

  @doc since: "1.4"
  @spec find(integer) :: Debiteurenbeheer.response()
  def find(id) do
    Client.get("/sales_invoices/#{id}")
  end

  @doc """
  Fetch outstanding invoices.
  For single resource use `Debiteurenbeheer.Import.Moneybird.Invoices.list/1`
  For more documentation about Enum, see `Enum`

      iex> Debiteurenbeheer.Import.Moneybird.Invoices.list()
      :ok

  """
  @deprecated "Use `Invoices.list/1` instead"
  def list do
    # First fetch all invoice ids
    # TODO: Only fetch paid invoices
    response =
      Client.get!(
        "/sales_invoices/synchronization.json?filter=state%3Apaid",
        headers()
      ).body

    invoice_ids =
      Enum.map(response, fn item ->
        item["id"]
        |> String.to_integer()
      end)

    # Split invoice_ids in groups of 10 because of max of 10 invoices per request
    invoice_ids_groups = Enum.chunk_every(invoice_ids, 10)

    Enum.map(invoice_ids_groups, fn ids ->
      Task.async(fn -> fetch_invoices_by_ids(ids) end)
    end)
    |> Enum.map(fn task -> Task.await(task) end)
    |> List.flatten()
  end

  defp fetch_invoices_by_ids(ids) when length(ids) == 0, do: []

  defp fetch_invoices_by_ids(ids) do
    body =
      %{ids: ids}
      |> Poison.encode!()

    response = Client.post!("/sales_invoices/synchronization", body, headers()).body
    response
  end

  @doc """
  Fetch outstanding invoices with given state

  State can be one of `open`, `paid`, `draft`, `late`
  """
  @spec list() :: Debiteurenbeheer.response()
  def list(state) do
    per_page = 3

    Client.get("/sales_invoices?filter=state%3A#{state}&per_page=#{per_page}")
  end
end
