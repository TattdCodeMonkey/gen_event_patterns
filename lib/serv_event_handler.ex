defmodule ServerEventHandler do
    use GenEvent
    require Logger
    @moduledoc """ 
    Event Handler that will be monitored with a plain GenServer
    """

    def init(_) do
       {:ok, {}}
	end

    def handle_event({:log, msg}, state) do
        "handled log: #{inspect msg} in #{__MODULE__}"
        |> Logger.info

        {:ok, state}
    end

    def handle_event({:crash, _}, state) do
        "crash event handler #{__MODULE__}"
        |> Logger.info

        1 = 2
    end

    def handle_event(event, state) do
        "handled event: #{inspect event} in #{__MODULE__}"
        |> Logger.info

        {:ok, state}
    end
end
