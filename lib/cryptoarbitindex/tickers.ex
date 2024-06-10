defmodule CryptoArbitIndex.Tickers do
  alias CryptoArbitIndex.Helpers

  @url_indodax_ticker Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_indodax_ticker]
  @url_indodax_usdt_idr Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_indodax_usdt_idr_price]
  @url_bitfinex_ticker Application.compile_env(:cryptoarbitindex, CryptoArbitIndex)[:url_bitfinex_ticker]

  def fetch_indodax_ticker do
    case Finch.build(:get, @url_indodax_ticker) |> Finch.request(CryptoArbitIndex.Finch) do
      {:ok, %Finch.Response{status: _status, body: body}} ->
        idr_pairs =
          body
          |> Jason.decode!()
          |> Map.fetch!("tickers")
          |> Enum.filter(fn {key, _value} ->
            String.ends_with?(key, "_idr") and key != "usdt_idr"
          end)
          |> Enum.map(fn {pair_key, map_value} ->
            Helpers.format_indodax_map(map_value, pair_key)
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
          |> Enum.filter(fn [head | _tail] ->
            !String.starts_with?(head, "f")
              and !String.contains?(head, "TEST")
              and !String.contains?(head, "USDT")
              and String.ends_with?(head, "USD")
          end)
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

  def fetch_usd_to_idr_price do
    case Finch.build(:get, @url_indodax_usdt_idr) |> Finch.request(CryptoArbitIndex.Finch) do
      {:ok, %Finch.Response{status: _status, body: body}} ->
        usdt_idr =
          body
          |> Jason.decode!()
          |> Map.fetch!("ticker")
          |> Helpers.format_indodax_map("usdt_idr")

        {:ok, usdt_idr}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
