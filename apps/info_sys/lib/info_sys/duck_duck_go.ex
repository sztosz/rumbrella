defmodule InfoSys.DuckDuckGo do
  alias InfoSys.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end

  def fetch(query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_json()
    |> get_abstract_text()
    |> send_result(query_ref, owner)
  end

  defp fetch_json(query_str) do
    {:ok, {_, _, body}} = :httpc.request(
      String.to_charlist("http://api.duckduckgo.com/?q=#{URI.encode(query_str)}&format=json")
    )
    body
  end

  def get_abstract_text(body) do
    {:ok, map} = Poison.Parser.parse(~s(#{body}))
    {:ok, abtract} = Map.fetch(map, "AbstractText")
    abtract
  end

  defp send_result(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end

  defp send_result(answer, query_ref, owner) do
    results = [%Result{backend: "duckduckgo", score: 80, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end
end
