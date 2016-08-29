ExUnit.start

# Mix.Task.run "ecto.create", ~w(-r Rumbl.Repo --quiet)
# Mix.Task.run "ecto.migrate", ~w(-r Rumbl.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Rumbl.Repo, :manual)
