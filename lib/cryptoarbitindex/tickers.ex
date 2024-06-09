defmodule CryptoArbitIndex.Tickers do
  require Logger

  @url_indodax_ticker Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_indodax_ticker]

  def fetch_indodax_ticker do
    case Finch.build(:get, @url_indodax_ticker) |> Finch.request(CryptoArbitIndex.Finch) do
      {:ok, %Finch.Response{status: _status, body: body}} ->
        idr_pairs =
          body
          |> Jason.decode!()
          |> Map.fetch!("tickers")
          |> Enum.filter(fn {key, _value} -> String.ends_with?(key, "_idr") end)
          |> Enum.map(fn {key, value} -> Map.put(value, "pair", key) end)

        {:ok, idr_pairs}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
