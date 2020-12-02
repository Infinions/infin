use Mix.Config

config :logger, level: :info

config :infin, InfinWeb.Endpoint,
  load_from_system_env: true,
  http: [port: System.get_env("PORT") || "4000"],
  url: [
    #scheme: "https",
    scheme: "http",
    host: System.get_env("HOST") || "localhost",
    port: System.get_env("PORT") || "4000"
  ],
  #force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  pt_invoices_url: "#{System.get_env("PT_INVOICES_HOST") || "localhost"}:#{System.get_env("PT_INVOICES_PORT") || "3000"}",
  pt_sibsapimarket: [
    url: System.fetch_env!("PT_SIBSAPIMARKET_HOST"),
    apiKey: System.fetch_env!("PT_SIBSAPIMARKET_APIKEY")
  ]

config :infin, Infin.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  #ssl: true
  ssl: false
