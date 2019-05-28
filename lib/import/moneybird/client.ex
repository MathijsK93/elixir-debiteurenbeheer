defmodule Debiteurenbeheer.Import.Moneybird.Client do
  use HTTPoison.Base

  # Demo administration
  @endpoint "https://moneybird.com/api/v2/"
  @administration "107330655556208014"
  @api_key "0bde74e1dc5a3c6627d55228c1d4fb0faa531de64f6f1f35fd7586883932b3f2"

  def process_request_url(url) do
    @endpoint <> @administration <> url
  end

  def process_response_body(body), do: Poison.decode!(body)
end
