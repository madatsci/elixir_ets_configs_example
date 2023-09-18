defmodule ConfigsExample.Configs.ProductRisk do
  use ConfigsExample.Configs.Config

  defp prepare_rows(%{"continents" => continents}) do
    continents
    |> Map.to_list()
  end
end
