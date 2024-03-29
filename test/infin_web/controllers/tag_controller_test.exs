defmodule InfinWeb.TagControllerTest do
  use InfinWeb.ConnCase

  import Infin.Factory
  alias Infin.Invoices

  setup :register_and_log_in_user

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:tag) do
    company = insert(:company)
    insert(:tag, company_id: company.id)
  end

  describe "index" do
    test "lists all tag", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tag"
    end
  end

  describe "new tag" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "create tag" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tag_path(conn, :show, id)

      conn = get(conn, Routes.tag_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tag"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "edit tag" do
    setup [:create_tag]

    test "renders form for editing chosen tag", %{conn: conn, tag: tag, user: user} do
      Invoices.change_tag_company(tag, user.company)

      conn = get(conn, Routes.tag_path(conn, :show, tag))
      assert html_response(conn, 200) =~ "Show Tag"
    end
  end

  describe "update tag" do
    setup [:create_tag]

    test "redirects when data is valid", %{conn: conn, tag: tag, user: user} do
      Invoices.change_tag_company(tag, user.company)

      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @update_attrs)
      assert redirected_to(conn) == Routes.tag_path(conn, :show, tag)

      conn = get(conn, Routes.tag_path(conn, :show, tag))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag, user: user} do
      Invoices.change_tag_company(tag, user.company)

      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "Show Tag"
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag, user: user} do
      Invoices.change_tag_company(tag, user.company)

      conn = delete(conn, Routes.tag_path(conn, :delete, tag))
      assert redirected_to(conn) == Routes.tag_path(conn, :index)
    end
  end

  defp create_tag(_) do
    tag = fixture(:tag)
    %{tag: tag}
  end
end
