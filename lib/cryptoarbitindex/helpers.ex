defmodule CryptoArbitIndex.Helpers do
  def to_float(number) do
    cond do
      is_integer(number) -> number / 1
      is_float(number) -> number
      is_binary(number) ->
        cond do
          number == "" -> 0.0
          String.contains?(number, ".") -> String.to_float(number)
          !String.contains?(number, ".") -> String.to_integer(number) / 1
          true -> 0.0
        end
      true -> 0.0
    end
  end

  def rfc1123_to_unix_seconds(datetime_str) do
    case Timex.parse(datetime_str, "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} GMT") do
      {:ok, datetime} ->
        naive_to_unix(datetime)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def naive_to_unix(naive_datetime) do
    case DateTime.from_naive(naive_datetime, "Etc/UTC") do
      {:ok, datetime} -> DateTime.to_unix(datetime)
      {:error, reason} -> {:error, reason}
    end
  end
end
