defmodule ConfigsExample.ConfigSupervisor do
  use Supervisor

  require Logger

  @children Application.compile_env!(:configs_example, :config_system) |> Keyword.fetch!(:modules)

  def start_link(opts), do: Supervisor.start_link(__MODULE__, opts, name: __MODULE__)

  def init(_opts) do
    Logger.info("Starting config system...")
    Supervisor.init(children(), strategy: :one_for_one)
  end

  defp children do
    @children
    |> Enum.map(fn {module, filename} ->
      {module, %{filename: filename, name: module}}
    end)
  end
end
