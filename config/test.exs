use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bitch_slack, BitchSlack.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bitch_slack, BitchSlack.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bitch_slack_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
