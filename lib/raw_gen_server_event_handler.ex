defmodule RawGenServerEventHandler do
    require Logger
    @moduledoc """
    This server adds a basic event handler using add_handler instead of
    add_mon_handler. This handler is not supervised and once it crashes it will
    not be restarted
    """

    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, []);
    end

    def init([opts]) do
        Logger.info("starting #{opts.name} handler")

        GenEvent.add_handler(opts.manager_name, EventHandler, [])
        {:ok, opts}
    end
end
