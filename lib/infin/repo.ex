defmodule Infin.Repo do
  use Ecto.Repo,
    otp_app: :infin,
    adapter: Ecto.Adapters.Postgres
end
