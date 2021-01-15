defmodule Infin.SaftParser do
  import SweetXml
  alias Infin.Revenue

  def parse_xml(file, company_id) do
    if Path.extname(file) != ".xml" do
      {:error, "Unsupported SAF-T."}
    else
      case File.read(file) do
        {:ok, xml_body} -> {:ok, parse_body(xml_body, company_id)}
        {:error, _reason} -> {:error, "Unsupported SAF-T."}
      end
    end
  end

  defp parse_body(file_body, company_id) do
    content_map =
      parse(file_body)
      |> xmap(
        header: [
          ~x"//AuditFile/Header",
          company_id: ~x"./CompanyID/text()"s,
          tax_registration_number: ~x"./TaxRegistrationNumber/text()"s,
          company_name: ~x"./CompanyID/text()"s,
          start_date: ~x"./StartDate/text()"s,
          end_date: ~x"./EndDate/text()"s,
          currency_code: ~x"./CurrencyCode/text()"s,
          product_company_tax_id: ~x"./ProductCompanyTaxID/text()"s
        ],
        source_documents: [
          ~x"//AuditFile/SourceDocuments",
          sales_invoices: [
            ~x"./SalesInvoices",
            invoices: [
              ~x"./Invoice"l,
              invoice_number: ~x"./InvoiceNo/text()"s,
              invoice_date: ~x"./InvoiceDate/text()"s,
              customer_id: ~x"./CustomerID/text()"s,
              products: [
                ~x"./Line"l,
                line_number: ~x"./LineNumber/text()"i,
                product_code: ~x"./ProductCode/text()"s,
                product_description: ~x"./ProductDescription/text()"s,
                quantity: ~x"./Quantity/text()"i,
                unit_price: ~x"./UnitPrice/text()"f,
                credit_amount: ~x"./CreditAmount/text()"f,
                tax: [
                  ~x"./Tax",
                  tax_percentage: ~x"./TaxPercentage/text()"i
                ]
              ],
              document_totals: [
                ~x"./DocumentTotals",
                tax_payable: ~x"./TaxPayable/text()"f,
                net_total: ~x"./NetTotal/text()"f,
                gross_total: ~x"./GrossTotal/text()"f,
                payment_terms: ~x"./Settlement/PaymentTerms/text()"s,
                payment_details: [
                  ~x"./Payment",
                  payment_mechanism: ~x"./PaymentMechanism/text()"s,
                  payment_amount: ~x"./PaymentAmount/text()"f,
                  payment_date: ~x"./PaymentDate/text()"s
                ]
              ]
            ],
            total_number: ~x"./NumberOfEntries/text()"i,
            total_debit: ~x"./TotalDebit/text()"f,
            total_credit: ~x"./TotalCredit/text()"f
          ]
        ]
      )

    generate_income_list(
      content_map.source_documents.sales_invoices.invoices,
      [],
      company_id
    )
  end

  defp generate_income_list([], final_list, _company_id) do
    final_list
  end

  defp generate_income_list([head | tail], final_list, company_id) do
    result_list = final_list ++ [generate_income(head, company_id)]
    generate_income_list(tail, result_list, company_id)
  end

  defp generate_income(map_invoice, company_id) do
    attributes = %{
      value: round(map_invoice.document_totals.gross_total * 100),
      date: map_invoice.invoice_date,
      description: "Tax ID: " <> map_invoice.customer_id,
      company_id: company_id
    }

    Revenue.create_income(attributes)
  end
end
