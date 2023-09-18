defmodule ConfigsExample.Configs.CountryRisk do
  use ConfigsExample.Configs.Config

  defp prepare_rows(%{"countries" => countries}) do
    countries
    |> Map.to_list()
  end
end
