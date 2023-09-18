defmodule ConfigsExample.Configs.Config do
  defmacro __using__(_opts) do
    quote do
      use GenServer

      require Logger

      def start_link(%{filename: filename, name: name}) do
        GenServer.start_link(__MODULE__, filename, name: name)
      end

      def init(filename) do
        :ets.new(ets_table_name(), [:named_table, :set, :protected])

        # read data from DB
        # case do ...
        # [] -> load into ets
        # {:error, ...} -> load_from_file, write to db, load into ets

        with {:ok, data} <- read_file(filename),
             {:ok, rows} <- prepare_rows(data),
             :ok <- write_data_into_ets(rows) do
          {:ok, %{filename: filename}, {:continue, :log}}
        else
          {:error, reason} ->
            {:stop, "Could not start #{__MODULE__}, reason: #{inspect(reason)}"}
        end
      end

      def get_all_records, do: :ets.tab2list(ets_table_name())

      def get_record(name) do
        case :ets.lookup(ets_table_name(), name) do
          [record] -> {:ok, record}
          _ -> {:error, "not found"}
        end
      end

      def handle_continue(:log, %{filename: filename} = state) do
        Logger.info("Started #{__MODULE__} reading from file #{filename}")
        {:noreply, state}
      end

      defp ets_table_name, do: __MODULE__

      defp read_file(filename) do
        Path.join(Application.app_dir(:configs_example), "/priv/config/#{filename}")
        |> YamlElixir.read_from_file()
      end

      defp prepare_rows(_data), do: raise("prepare_rows must be implemented")

      defoverridable prepare_rows: 1

      defp write_data_into_ets(rows) do
        table_name = ets_table_name()

        with true <- :ets.delete_all_objects(table_name),
             true <- :ets.insert(table_name, rows),
             do: :ok
      end
    end
  end
end
