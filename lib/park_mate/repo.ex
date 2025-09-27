defmodule ParkMate.Repo do
  use Ecto.Repo,
    otp_app: :park_mate,
    adapter: Ecto.Adapters.Postgres
end
