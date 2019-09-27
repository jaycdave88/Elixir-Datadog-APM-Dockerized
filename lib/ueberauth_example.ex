defmodule UeberauthExample do
  @moduledoc false

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    spandex_datadog_options =
    [
      host: System.get_env("DATADOG_HOST") || "localhost",
      port: System.get_env("DATADOG_PORT") || 8126,
      batch_size: System.get_env("SPANDEX_BATCH_SIZE") || 10,
      sync_threshold: System.get_env("SPANDEX_SYNC_THRESHOLD") || 100,
      http: HTTPoison,
      verbose?: true
    ]

    children = [
      # Start the Ecto repository
      supervisor(UeberauthExample.Repo, []),
      # Start the endpoint when the application starts
      supervisor(UeberauthExampleWeb.Endpoint, []),
      # Here you could define other workers and supervisors as children
      # worker(UeberauthExample.Worker, [arg1, arg2, arg3]),
      worker(SpandexDatadog.ApiServer, [spandex_datadog_options])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UeberauthExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UeberauthExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
