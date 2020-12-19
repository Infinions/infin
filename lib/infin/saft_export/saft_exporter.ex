defmodule Infin.SaftExport.SaftExporter do

  import XmlBuilder

  def generate_XML() do

    content = element(:AuditFile,
        %{"\n\txmlns": "urn:OECD:StandardAuditFile-Tax:PT_1.04_01",
          "\n\txmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"}, [
            generate_header(),
            element(:MasterFiles, [
              generate_customer(),
              generate_tax_table([1,2,3])
            ]),
            element(:SourceDocuments, [
              generate_sales_invoices([1,2,3])
            ])
          ])

    |> generate

    File.write("saft.xml", content)
  end


  def generate_header() do

    current_date = Date.utc_today()
    date = Integer.to_string(current_date.year) <> "-"
        <> Integer.to_string(current_date.month) <> "-"
        <> Integer.to_string(current_date.day)

    header = element(:Header, [
      element(:AuditFileVersion, "1.04_01"),
      element(:CompanyID, ""),
      element(:TaxRegistrationNumber, ""),
      element(:TaxAccountingBasis, ""),
      element(:CompanyName, ""),
      element(:BusinessName, ""),
      element(:CompanyAddress, [
        element(:AddressDetail, ""),
        element(:City, ""),
        element(:PostalCode, ""),
        element(:Country, ""),
      ]),
      element(:FiscalYear, ""),
      element(:CompanyID, ""),
      element(:StartDate, ""),
      element(:EndDate, ""),
      element(:CompanyID, ""),
      element(:CurrencyCode, ""),
      element(:DateCreated, date),
      element(:TaxEntity, ""),
      element(:ProductCompanyTaxID, ""),
      element(:SoftwareCertificateNumber, ""),
      element(:ProductID, ""),
      element(:ProductVersion, "")
    ])
    header
  end

  #TODO: receive customer data (app format) as argument
  def generate_customer() do

    customer = element(:Customer, [
      element(:CustomerID, ""),
      element(:AccountID, ""),
      element(:CustomerTaxID, ""),
      element(:CompanyName, ""),
      element(:BillingAddress, [
        element(:AddressDetail, ""),
        element(:City, ""),
        element(:PostalCode, ""),
        element(:Country, ""),
      ]),
      element(:SelfBillingIndicator, ""),
    ])

    customer
  end

  #TODO: receive tax entry (app format) as argument to get the data from
  def generate_tax_table_entry() do

    entry = element(:TaxTableEntry, [
      element(:TaxType, ""),
      element(:TaxCountryRegion, ""),
      element(:TaxCode, ""),
      element(:Description, ""),
      element(:TaxPercentage, ""),
    ])

    entry
  end


  def generate_tax_table_entry_list([], final_list) do final_list end

  def generate_tax_table_entry_list([_head|tail], final_list) do
    result_list = final_list ++ [generate_tax_table_entry()]
    generate_tax_table_entry_list(tail, result_list)
  end


  def generate_tax_table(tax_entry_list) do

    tax_table = element(:TaxTable, generate_tax_table_entry_list(tax_entry_list, []))
    tax_table

  end


  def generate_sales_invoices(invoice_list) do

    sales_invoices = element(:SalesInvoices, [
      element(:NumberOfEntries, ""),
      element(:TotalDebit, ""),
      element(:TotalCredit, "")] ++ generate_invoice_list(invoice_list, [])
    )
    sales_invoices
  end


  #TODO: receive an invoice (app format) as argument to get the data from
  def generate_invoice() do
    invoice = element(:Invoice, [
      element(:InvoiceNo, ""),
      element(:ATCUD, ""),
      element(:DocumentStatus, [
        element(:InvoiceStatus, ""),
        element(:InvoiceStatusDate, ""),
        element(:SourceID, ""),
        element(:SourceBilling, ""),
      ]),
      element(:Hash, ""),
      element(:HashControl, ""),
      element(:Period, ""),
      element(:InvoiceDate, ""),
      element(:InvoiceType, ""),
      element(:SpecialRegimes, [
        element(:SelfBillingIndicator, ""),
        element(:CashVATSchemeIndicator, ""),
        element(:ThirdPartiesBillingIndicator, ""),
      ]),
      element(:SourceID, ""),
      element(:SystemEntryDate, ""),
      element(:CustomerID, ""),
      element(:Line, [
        element(:LineNumber, ""),
        element(:ProductCode, ""),
        element(:ProductDescription, ""),
        element(:Quantity, ""),
        element(:UnitOfMeasure, ""),
        element(:UnitPrice, ""),
        element(:TaxPointDate, ""),
        element(:Description, ""),
        element(:CreditAmount, ""),
        element(:Tax, [
          element(:TaxType, ""),
          element(:TaxCountryRegion, ""),
          element(:TaxCode, ""),
          element(:TaxPercentage, ""),
        ]),
        element(:SettlementAmount, ""),
      ]),
      element(:DocumentTotals, [
        element(:TaxPayable, ""),
        element(:NetTotal, ""),
        element(:GrossTotal, ""),
        element(:Settlement, [
          element(:PaymentTerms, "")
        ]),
        element(:Payment, [
          element(:PaymentMechanism, ""),
          element(:PaymentAmount, ""),
          element(:PaymentDate, ""),
        ]),
      ]),
    ])

    invoice
  end


  #TODO: receive a list of invoices(app format) as argument
  def generate_invoice_list([], final_list) do final_list end

  def generate_invoice_list([_head|tail], final_list) do
    result_list = final_list ++ [generate_invoice()]
    generate_invoice_list(tail, result_list)
  end

end
