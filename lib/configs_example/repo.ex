defmodule ConfigsExample.Repo do
  use Ecto.Repo,
    otp_app: :configs_example,
    adapter: Ecto.Adapters.Postgres
end
