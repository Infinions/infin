defmodule InfinWeb.DashboardLive.Graph do
  use InfinWeb, :live_component

  alias Infin.Companies

  @impl true
  def update(assigns, socket) do
    company = Companies.get_company(assigns.company_id)
    assign(socket, company_nif: company.nif)

    {:ok, assign(socket, :company_nif, company.nif)}
  end
end
