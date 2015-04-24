defmodule GenServerMonitoredEventHandler do
    require Logger
    @moduledoc """
    starts a monitored EventHandler, but does not implement handle_info function
    to explicitly restart event handler. instead this server will crash and rely
    on its supervisor to restart it, which will also restart the event handler
    """

    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts,[]);
    end

    def init([opts]) do
        "starting #{opts.name} monitored handler"
        |> Logger.info

        :ok = GenEvent.add_mon_handler(opts.manager_name, ServerEventHandler, [])
        {:ok, opts}
    end
end
