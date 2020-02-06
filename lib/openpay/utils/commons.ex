defmodule Openpay.Utils.Commons do
  @moduledoc """
  This module contains common utils.
  """
  @spec to_camel(any(), :lower | :upper) :: binary()
  def to_camel(word, option \\ :lower) do
    case Regex.split(~r/(?:^|[-_])|(?=[A-Z])/, to_string(word)) do
      words ->
        words
        |> Enum.filter(&(&1 != ""))
        |> camelize(option)
        |> Enum.join()
    end
  end

  @spec from_json(maybe_improper_list()) :: [any()]
  def from_json(lst) when is_list(lst) do
    lst
    |> Enum.map(fn {key, value} -> {to_camel(key), value} end)
  end

  defp camelize([], :upper), do: []

  defp camelize([h | tail], :lower) do
    [to_lower(h)] ++ camelize(tail, :upper)
  end

  defp camelize([h | tail], :upper) do
    [capitalize(h)] ++ camelize(tail, :upper)
  end

  defp capitalize(word), do: String.capitalize(word)
  defp to_lower(word), do: String.downcase(word)

  def is_empty(str) when is_bitstring(str) do
    total = str |> String.trim() |> String.length()

    case total do
      0 -> true
      _ -> false
    end
  end

  def is_empty(map) when is_map(map) and map_size(map) == 0, do: true
  def is_empty(map) when is_map(map) and map_size(map) > 0, do: false

  def equals_to(string, size), do: String.length(string) == size

  def map_to_atom(data) when is_list(data) do
    data |> Enum.map(&map_to_atom/1)
  end

  def map_to_atom(data) when is_map(data) do
    data
    |> Enum.into(%{}, fn {k, v} -> {key_to_atom(k), when_is_key(v)} end)
  end

  def into(schema_type, map), do: struct(schema_type, map)

  # Privates
  defp when_is_key(data) when is_map(data) do
    map_to_atom(data)
  end

  defp when_is_key(data) when is_list(data) do
    data
    |> Enum.map(fn key -> when_is_key(key) end)
  end

  defp when_is_key(data) do
    data
  end

  defp key_to_atom(str) do
    str |> Macro.underscore() |> String.to_atom()
  end
end
