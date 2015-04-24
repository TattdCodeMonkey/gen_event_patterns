defmodule HanldersSupervisor do
    use Supervisor

    @moduledoc """
    Supervises the GenEvent test handlers
    """

    def start_link(mgr_name), do: Supervisor.start_link(__MODULE__,mgr_name, [])

    def init(manager_name) do
        [
            worker(RawGenServerEvenHandler, [[
                %{name: "raw event handler", manager_name: manager_name}
            ]]),
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
