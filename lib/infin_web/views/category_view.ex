defmodule InfinWeb.CategoryView do
  use InfinWeb, :view

  def contains_category?(assigns) do
    assigns[:category]
  end
end
