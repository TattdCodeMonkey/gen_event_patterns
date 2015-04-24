defmodule GenEventPatterns do
    @name :event_manager

    def start_test do
        EventSupervisor.start_link
    end

    def test_msg do
        test_msg("test")
    end

    def test_msg(msg) do
        GenEvent.notify(@name, {:log, msg})
    end

    def crash_handlers, do: GenEvent.notify(@name, {:crash, "boom"})
    def crash_manager, do: @name |> Process.whereis |> Process.exit(:boom)

    def run_test do
        start_test
        test_msg
        crash_handlers
        test_msg
        crash_manager
        test_msg
    end
end
