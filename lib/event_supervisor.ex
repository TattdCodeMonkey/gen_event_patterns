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
            supervisor(HanldersSupervisor, [manager_name])
        ]
        |> supervise(strategy: :one_for_all)
    end
end
