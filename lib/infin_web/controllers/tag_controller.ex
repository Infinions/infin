defmodule InfinWeb.TagController do
  use InfinWeb, :controller

  alias Infin.Invoices
  alias Infin.Invoices.Tag

  def index(conn, _params, company_id) do
    tags = Invoices.list_company_tags(company_id)
    render(conn, "index.html", tags: tags)
  end

  def new(conn, _params, _c) do
    changeset = Invoices.change_tag(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}, company_id) do
    case Invoices.create_tag(tag_params, company_id) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.tag_path(conn, :show, tag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, company_id) do
    case Invoices.get_tag(id) do
      nil ->
        index(conn, %{}, company_id)

      tag ->
        cond do
          company_id == tag.company_id ->
            changeset = Invoices.change_tag(tag)
            render(conn, "show.html", tag: tag, changeset: changeset)

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def update(conn, %{"id" => id, "tag" => tag_params}, company_id) do
    case Invoices.get_tag(id) do
      nil ->
        index(conn, %{}, company_id)

      tag ->
        cond do
          company_id == tag.company_id ->
            case Invoices.update_tag(tag, tag_params) do
              {:ok, tag} ->
                conn
                |> put_flash(:info, "Tag updated successfully.")
                |> redirect(to: Routes.tag_path(conn, :show, tag))

              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "show.html", tag: tag, changeset: changeset)
            end

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def delete(conn, %{"id" => id}, company_id) do
    case Invoices.get_tag(id) do
      nil ->
        index(conn, %{}, company_id)

      tag ->
        cond do
          company_id == tag.company_id ->
            {:ok, _tag} = Invoices.delete_tag(tag)

            conn
            |> put_flash(:info, "Tag deleted successfully.")
            |> redirect(to: Routes.tag_path(conn, :index))

          true ->
            index(conn, %{}, company_id)
        end
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.company.id]
    apply(__MODULE__, action_name(conn), args)
  end
end
