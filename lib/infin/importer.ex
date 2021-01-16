defmodule Infin.Importer do
  @moduledoc """
  The Importer context.
  """

  import Ecto.Query, warn: false
  alias Infin.Invoices

  require Logger

  def import_invoices_pt(nif, password, start_date, end_date, company_id) do
    expected = %{
      "nif" => nif,
      "password" => password,
      "startDate" => start_date,
      "endDate" => end_date
    }

    enumerable = Jason.encode!(expected) |> String.split("")
    headers = %{"Content-type" => "application/json"}

    case HTTPoison.post(
           Application.get_env(:infin, InfinWeb.Endpoint)[:pt_invoices_url] <> "/invoices",
           {:stream, enumerable},
           headers
         ) do
      {:ok, response} ->
        IO.inspect(response)
        case response.status_code do
          200 ->
            %HTTPoison.Response{body: body} = response
            object = Jason.decode!(body)
            invoices = Map.get(object, "invoices", [])
            Invoices.insert_fectched_invoices_pt(invoices, company_id)
            {:ok, "Invoices imported"}

          400 ->
            %HTTPoison.Response{body: body} = response
            object = Jason.decode!(body)
            {:error, object["message"]}

          _ ->
            %{service: "pt_invoices", message: response} |> inspect() |> Logger.error
            {:error, "Service not available"}
        end

      {_, message} ->
        message |> inspect() |> Logger.error
        {:error, "Service not available"}
    end
  end
end
