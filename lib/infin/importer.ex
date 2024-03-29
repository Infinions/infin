defmodule Infin.Importer do
  @moduledoc """
  The Importer context.
  """

  import Ecto.Query, warn: false

  alias Infin.Companies.Company
  alias Infin.Invoices
  alias Infin.Repo

  require Logger

  def import_invoices_pt(nif, password, start_date, end_date, company_id) do
    sd = Date.from_iso8601!(start_date) |> Map.fetch!(:year)
    ed = Date.from_iso8601!(end_date) |> Map.fetch!(:year)

    if sd == ed do
      import(nif, password, start_date, end_date, company_id)
    else
      {:error, "Start and end date must be in the same year"}
    end
  end

  def import(nif, password, start_date, end_date, company_id) do
    expected = %{
      "nif" => nif,
      "password" => password,
      "startDate" => start_date,
      "endDate" => end_date
    }

    enumerable = Jason.encode!(expected) |> String.split("")
    headers = %{"Content-type" => "application/json"}

    case HTTPoison.post(
           Application.get_env(:infin, InfinWeb.Endpoint)[:pt_invoices_url] <>
             "/invoices",
           {:stream, enumerable},
           headers,
           [timeout: 15_000]
         ) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            %HTTPoison.Response{body: body} = response
            object = Jason.decode!(body)
            invoices = Map.get(object, "invoices", [])
            {:ok, result} = get_category_prediction(invoices, company_id)

            categories = result.body["data"]["categorize_invoices"]

            case categories do
              nil ->
                {:ok, "No invoices to import"}

              "[]" ->
                Invoices.insert_fectched_invoices_pt(invoices, company_id)

                {:ok,
                 "Invoices imported, but insufficient data to automatic categorization"}

              _ ->
                Invoices.insert_fectched_invoices_pt(
                  categorize_invoices(invoices, Jason.decode!(categories)),
                  company_id
                )

                {:ok, "Invoices imported"}
            end

          400 ->
            %HTTPoison.Response{body: body} = response
            object = Jason.decode!(body)
            {:error, object["message"]}

          _ ->
            %{service: "pt_invoices", message: response}
            |> inspect()
            |> Logger.error()

            {:error, "Service not available"}
        end

      {_, message} ->
        message |> inspect() |> Logger.error()
        {:error, "Service not available"}
    end
  end

  defp get_category_prediction(invoices, company_id) do
    analytics_url =
      Application.get_env(:infin, InfinWeb.Endpoint)[:analytics_url]

    parsed_invoices =
      transform_invoices(invoices, company_id) |> String.slice(1..-2)

    Neuron.Config.set(url: analytics_url)

    Neuron.query(
      "{ categorize_invoices(invoices: \"{\\\"list\\\": #{parsed_invoices}}\")}",
      %{},
      connection_opts: [recv_timeout: 15_000]
    )
  end

  defp transform_invoices(invoices, company_id) do
    company = Company |> Repo.get(company_id)

    invoices
    |> Enum.map(fn i ->
      %{
        nif: company.nif,
        company_seller_name: i["nomeEmitente"],
        total_value: i["valorTotal"],
        doc_emission_date: i["dataEmissaoDocumento"]
      }
    end)
    |> Jason.encode!()
    |> Jason.encode!()
  end

  defp categorize_invoices(invoices, categories) do
    invoices
    |> Enum.with_index(1)
    |> Enum.map(fn {invoice, index} ->
      invoice
      |> Map.put(:category_id, categories[to_string(index)])
      |> Map.put(:automatic_category, true)
    end)
  end
end
