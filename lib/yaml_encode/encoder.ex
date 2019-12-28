defmodule YamlEncode.Encoder do
  @moduledoc """
  YamlEncode main module
  """

  import YamlEncode.Quoter, only: [quotes?: 1]

  @doc """
  encodes map or a list of maps into a yaml document
  """
  @spec encode(map | [map]) :: {:ok, binary} | {:error, binary}
  def encode(map) when is_map(map) do
    {:ok, create_yaml(map)}
  rescue
    _e in FunctionClauseError -> {:error, "invalid map"}
  end

  def encode(maps) when is_list(maps) do
    {:ok, maps |> Enum.map(&create_yaml/1) |> Enum.join("\n")}
  rescue
    _e in FunctionClauseError -> {:error, "invalid maps"}
  end

  defp create_yaml(map, n \\ 0)

  defp create_yaml(map, 0) do
    Enum.reduce(map, "---\n", &reduce_yaml/2)
  end

  defp create_yaml(map, n) do
    Enum.reduce(map, "", &reduce_yaml(&1, &2, n))
  end

  defp reduce_yaml(tuple, acc, n \\ 0)

  defp reduce_yaml({k, v}, acc, n) do
    convert_to_string(
      {
        convert_to_key(k, n),
        convert_to_value(v, n)
      },
      acc
    )
  end

  defp convert_to_string({k, v}, "---\n" = acc) do
    "#{acc}#{k}:#{v}"
  end

  defp convert_to_string({k, v}, acc) do
    "#{acc}\n#{k}:#{v}"
  end

  defp convert_to_key(key, n) when is_binary(key) and is_integer(n) do
    create_whitespace(n) <> print_quotes(key, quotes?(key))
  end

  defp print_quotes(key, false) when is_binary(key) do
    key
  end

  defp print_quotes(key, true) when is_binary(key) do
    "\"#{key}\""
  end

  defp convert_to_value(value, n) when is_list(value) do
    Enum.reduce(value, "", &convert_sublist_values(&1, &2, n))
  end

  defp convert_to_value(value, n) when is_map(value) do
    create_yaml(value, n + 1)
  end

  defp convert_to_value(value, _) when is_binary(value) do
    " #{print_quotes(value, quotes?(value))}"
  end

  defp convert_to_value(nil, _) do
    " null"
  end

  defp convert_to_value(value, _) when is_number(value) or is_boolean(value) do
    " #{value}"
  end

  defp convert_sublist_values(x, acc, n) when is_map(x) do
    "#{acc}\n#{create_whitespace(n + 1)}- #{String.trim(convert_to_value(x, n + 1))}"
  end

  defp convert_sublist_values(x, acc, n) do
    "#{acc}\n#{create_whitespace(n + 1)}-#{convert_to_value(x, n)}"
  end

  defp create_whitespace(number, spaces \\ "  ")
  defp create_whitespace(0, _spaces), do: ""

  defp create_whitespace(number, spaces) do
    String.duplicate(spaces, number)
  end
end
