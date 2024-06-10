defmodule CryptoArbitIndex.Worker do
  use GenServer

  # Client API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Server Callbacks
  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    perform_work()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    :timer.send_after(5_000, self(), :work) # Schedule work to be performed every 5 seconds
  end

  defp perform_work() do
    IO.puts("Performing scheduled work at #{inspect(DateTime.utc_now())}")
    # Add your work logic here
  end
end
