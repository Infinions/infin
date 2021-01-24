use Mix.Config

config :logger, level: :info

config :infin, InfinWeb.Endpoint,
  load_from_system_env: true,
  http: [port: System.get_env("SERVER_PORT") || "4000"],
  url: [
    # scheme: "https",
    scheme: "http",
    host: System.get_env("HOST") || "infin.com",
    port: System.get_env("PORT") || "443",
    path: "/app"
  ],
  # force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  pt_invoices_url:
    "#{System.get_env("PT_INVOICES_HOST") || "localhost"}:#{
      System.get_env("PT_INVOICES_PORT") || "3000"
    }",
  analytics_url:
    "#{System.get_env("ANALYTICS_HOST") || "localhost"}:#{
      System.get_env("ANALYTICS_PORT") || "5600"
    }#{System.get_env("ANALYTICS_PATH") || "5600"}",
  pt_sibsapimarket: [
    url:
      System.get_env("PT_SIBSAPIMARKET_HOST") ||
        "https://site1.sibsapimarket.com:8445/sibs/apimarket-sb",
    apiKey:
      System.get_env("PT_SIBSAPIMARKET_APIKEY") ||
        "073286e4-055b-472b-96ad-7ddd484333ec"
  ]

config :infin, Infin.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  # ssl: true
  ssl: false
