defmodule Infin.Repo do
  use Ecto.Repo,
    otp_app: :infin,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
