defmodule SupervisorMonitoredEventHandler do
    #use GenServer
    require Logger
    @moduledoc """
    starts a monitored EventHandler, and explicitly handles :gen_event_EXIT
    message. If the event handler exits for any reason that is not :normal or
    :shutdown then it is restarted.
    """

    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts,[]);
    end

    def init([opts]) do
        start_handler(opts)
        {:ok, opts}
    end

    def handle_info({:gen_event_EXIT, handler, reason}, state)
      when reason in [:normal, :shutdown] do
        "handler #{state.name} exited normally. stopping"
        |> Logger.info

        {:stop, reason, state}
    end

    def handle_info({:gen_event_EXIT, handler, reason}, state) do
        "handler #{state.name} exited. restarting..."
        |> Logger.info

        start_handler(state)
        {:noreply, state}
    end

    defp start_handler(opts) do
        "starting #{opts.name} monitored handler in supervised server"
        |> Logger.info

        :ok = GenEvent.add_mon_handler(opts.manager_name, SupervisorEventHandler, [])
    end
end
