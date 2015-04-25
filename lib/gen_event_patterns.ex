defmodule GenEventPatterns do
    @moduledoc """
    Call functions in following order to exercise implementations:

    start_test

    test_msg

    crash_handlers

    test_msg

    crash_manager

    test_msg
    """

    def start_test do
        EventSupervisor.start_link
    end

    def test_msg do
        test_msg("test")
    end

    def test_msg(msg) do
        GenEvent.notify(:event_manager, {:log, msg})
    end

    def crash_handlers, do: GenEvent.notify(:event_manager, {:crash, "boom"})
    def crash_manager, do: :event_manager |> Process.whereis |> Process.exit(:boom)
end
