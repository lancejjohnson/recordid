defmodule Recordid.Repo do
  use Ecto.Repo,
    otp_app: :recordid,
    adapter: Ecto.Adapters.Postgres
end
