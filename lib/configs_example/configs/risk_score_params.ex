defmodule ConfigsExample.Configs.RiskScoreParams do
  use ConfigsExample.Configs.Config

  defp prepare_rows(%{"formula" => formula}) do
    formula
    |> Map.to_list()
  end
end
