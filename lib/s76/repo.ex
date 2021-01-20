defmodule S76.Repo do
  use Ecto.Repo,
    otp_app: :s76,
    adapter: Ecto.Adapters.Postgres
end
