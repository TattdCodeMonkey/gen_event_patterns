defmodule SupervisorEventHandler do
    use GenEvent
    require Logger
    @moduledoc """
    Event Handler that will be monitored with a GenServer that explicitly
    handles the :gen_event_EXIT message and restarts the this event handler
    """

    def init(parent) do
       {:ok, parent}
	end

    def handle_event({:log, msg}, parent) do
        "handled log: #{inspect msg} in #{__MODULE__}"
        |> Logger.info

        {:ok, parent}
    end

    def handle_event({:crash, _}, parent) do
        "crash event handler #{__MODULE__}"
        |> Logger.info

        1 = 2
    end

    def handle_event(event, parent) do
        "handled event: #{inspect event} in #{__MODULE__}"
        |> Logger.info

        {:ok, parent}
    end
end
