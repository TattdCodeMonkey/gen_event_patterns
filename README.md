Elixir GenEvent Testing
================

This project is used to show three methods of adding event handlers to a `GenEvent` manager.

1. use `add_handler`:
this adds a handler to the `GenEvent` manager, but does not do any supervision and is not fault tolerant
2. use `add_mon_handler` without handling exits:
this adds a monitored handler to the `GenEvent` manager, but does not explicitly handle :gen_event_EXIT messages. instead it relies on crashing the server its in so that it can be restarted by its supervisor
3. user `add_mon_handler` handle exits:
this adds a monitored handler to the `GenEvent` manager, and explicitly handles exits. reading the event handler for any reason that is not `:normal` or `:shutdown`

In addition to the three handlers there are also two supervisors. One supervisor manages the three handlers with a `:one_for_one` strategy. The other manages the `GenEvent` manager and the handlers supervisor with a `:one_for_all` strategy. This ensures the handlers are re-added if the manager crashes for any reason.

## Generic Event Handler used in module
```elixir
defmodule EventHandler do
  use GenEvent
  require Logger

  def init(_) do
    {:ok, {}}
  end

  def handle_event({:log, msg}, state) do
    "handled log: #{inspect msg} in #{__MODULE__}"
    |> Logger.info

    {:ok, state}
  end

  def handle_event({:crash, _}, state) do
    "crash event handler #{__MODULE__}"
    |> Logger.info

    1 = 2
  end

  def handle_event(event, state) do
    "handled event: #{inspect event} in #{__MODULE__}"
    |> Logger.info

    {:ok, state}
  end
end
```

## Pattern 1 - basic event handler with no monitoring

```elixir
defmodule EventHandlerServer do
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, []);
  end

  def init([opts]) do
    GenEvent.add_handler(opts.manager_name, EventHandler, [])

    {:ok, opts}
  end
end
```

## Pattern 2 - monitored event handler
```elixir
defmodule EventHandlerServer do
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts,[]);
  end

  def init([opts]) do
    :ok = GenEvent.add_mon_handler(opts.manager_name, EventHandler, [])

    {:ok, opts}
  end
end
```

## Pattern 3 - monitored event handler, restarts handler on exit

```elixir
defmodule EventHandlerServer do
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts,[]);
  end

  def init([opts]) do
    start_handler(opts)
    {:ok, opts}
  end

  def start_handler(opts) do
    :ok = GenEvent.add_mon_handler(opts.manager_name, EventHandler, [])
  end

  def handle_info({:gen_event_EXIT, handler, reason}, state)
    when reason in [:normal, :shutdown] do
    {:stop, reason, state}
  end

  def handle_info({:gen_event_EXIT, handler, reason}, state) do
    start_handler(state)

    {:noreply, state}
  end
end
```
