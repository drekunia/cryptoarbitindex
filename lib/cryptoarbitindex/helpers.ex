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
end
