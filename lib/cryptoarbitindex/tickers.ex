defmodule CryptoArbitIndex.Tickers do
  require Logger
  alias CryptoArbitIndex.Helpers

  @url_indodax_ticker Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_indodax_ticker]
  @url_bitfinex_ticker Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_bitfinex_ticker]

  def fetch_indodax_ticker do
    case Finch.build(:get, @url_indodax_ticker) |> Finch.request(CryptoArbitIndex.Finch) do
      {:ok, %Finch.Response{status: _status, body: body}} ->
        idr_pairs =
          body
          |> Jason.decode!()
          |> Map.fetch!("tickers")
          |> Enum.filter(fn {key, _value} -> String.ends_with?(key, "_idr") end)
          |> Enum.map(fn {pair_key, map_value} ->
            map_value
            |> Enum.map(fn {key, value} ->
              float_value = if key != "server_time" and is_binary(value), do: Helpers.to_float(value), else: value

              {String.to_atom(key), float_value}
            end)
            |> Map.new()
            |> Map.put(:pair, pair_key)
          end)

        {:ok, idr_pairs}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_bitfinex_ticker do
    case Finch.build(:get, "#{@url_bitfinex_ticker}?symbols=ALL") |> Finch.request(CryptoArbitIndex.Finch) do
      {:ok, %Finch.Response{status: _status, body: body, headers: headers}} ->
        response_last_modified = Map.new(headers) |> Map.fetch!("last-modified") |> Helpers.rfc1123_to_unix_seconds()

        usd_pairs =
          body
          |> Jason.decode!()
          |> Enum.filter(fn [head | _tail] -> !String.starts_with?(head, "f") end)
          |> Enum.filter(fn [head | _tail] -> !String.contains?(head, "TEST") end)
          |> Enum.filter(fn [head | _tail] -> !String.contains?(head, "USDT") end)
          |> Enum.filter(fn [head | _tail] -> String.ends_with?(head, "USD") end)
          |> Enum.map(fn [symbol, bid, _bid_size, ask, _ask_size, _daily_change, _daily_change_relative, last_price, volume, high, low] ->
            %{
              buy: ask,
              high: high,
              last: last_price,
              low: low,
              pair: symbol,
              sell: bid,
              server_time: response_last_modified,
              vol_usd: volume
            }
          end)

        {:ok, usd_pairs}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
