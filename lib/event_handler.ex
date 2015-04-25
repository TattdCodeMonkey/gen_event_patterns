defmodule EventHandler do
    use GenEvent
    require Logger
    @moduledoc """
    basic EventHandler to be used with add_handler
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
