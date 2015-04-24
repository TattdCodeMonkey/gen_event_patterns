defmodule EventSupervisor do
    use Supervisor
    @moduledoc """
    Supervises the GenEvent manager and all three test handlers
    """

    def start_link, do: Supervisor.start_link(__MODULE__, [])

    def init(_) do
        manager_name = :event_manager
        [
            worker(GenEvent, [[name: manager_name]]),
            # worker(RawGenServerEvenHandler, [[
            #     %{name: "raw event handler", manager_name: manager_name}
            # ]]),
            worker(GenServerMonitoredEventHandler, [[
                %{name: "server monitored event handler", manager_name: manager_name}
            ]]),
            worker(SupervisorMonitoredEventHandler, [[
                %{name: "sup monitored event handler", manager_name: manager_name}
            ]])
        ]
        |> supervise(strategy: :one_for_one)
    end
end
