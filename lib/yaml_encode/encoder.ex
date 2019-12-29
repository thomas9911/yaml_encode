defmodule YamlEncode.Encoder do
  @moduledoc """
  YamlEncode main module
  """

  import YamlEncode.Quoter, only: [quotes?: 1]
  @default_spaces "  "
  @default_breakoff_length 80

  @doc """
  encodes map or a list of maps into a yaml document
  """
  @spec encode(map | [map], keyword) :: {:ok, binary} | {:error, binary}
  def encode(map, opts \\ [])

  def encode(map, opts) when is_map(map) do
    {:ok, create_yaml(map, 0, opts)}
  rescue
    _e in FunctionClauseError -> {:error, "invalid map"}
  end

  def encode(maps, opts) when is_list(maps) do
    {:ok, maps |> Enum.map(&create_yaml(&1, 0, opts)) |> Enum.join("\n")}
  rescue
    _e in FunctionClauseError -> {:error, "invalid maps"}
  end

  # defp create_yaml(map, n \\ 0, _opts)

  defp create_yaml(map, 0, opts) do
    Enum.reduce(map, "---\n", &reduce_yaml(&1, &2, 0, opts))
  end

  defp create_yaml(map, n, opts) do
    Enum.reduce(map, "", &reduce_yaml(&1, &2, n, opts))
  end

  defp reduce_yaml({k, v}, acc, n, opts) do
    convert_to_string(
      {
        convert_to_key(k, n, opts),
        convert_to_value(v, n, opts)
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

  defp convert_to_key(key, n, opts) when is_binary(key) and is_integer(n) do
    spaces = Keyword.get(opts, :spaces, @default_spaces)
    whitespaces = create_whitespace(n, spaces)
    whitespaces <> print_string(key, quotes?(key), false, whitespaces, 0)
  end

  defp convert_to_value(value, n, opts) when is_list(value) do
    Enum.reduce(value, "", &convert_sublist_values(&1, &2, n, opts))
  end

  defp convert_to_value(value, n, opts) when is_map(value) do
    create_yaml(value, n + 1, opts)
  end

  defp convert_to_value(value, n, opts) when is_binary(value) do
    spaces = Keyword.get(opts, :spaces, @default_spaces)
    break_off_length = Keyword.get(opts, :break_off_length, @default_breakoff_length)

    long_string =
      String.length(value) >= break_off_length && Keyword.get(opts, :use_folded_string, false)

    " #{
      print_string(
        value,
        quotes?(value),
        long_string,
        create_whitespace(n + 1, spaces),
        break_off_length
      )
    }"
  end

  defp convert_to_value(nil, _, _opts) do
    " null"
  end

  defp convert_to_value(value, _, _opts) when is_number(value) or is_boolean(value) do
    " #{value}"
  end

  defp convert_sublist_values(x, acc, n, opts) when is_map(x) do
    spaces = Keyword.get(opts, :spaces, @default_spaces)

    "#{acc}\n#{create_whitespace(n + 1, spaces)}- #{String.trim(convert_to_value(x, n + 1, opts))}"
  end

  defp convert_sublist_values(x, acc, n, opts) do
    spaces = Keyword.get(opts, :spaces, "  ")
    "#{acc}\n#{create_whitespace(n + 1, spaces)}-#{convert_to_value(x, n, opts)}"
  end

  defp print_string(key, false, false, _, _) when is_binary(key) do
    key
  end

  defp print_string(key, true, false, _, _) when is_binary(key) do
    "\"#{key}\""
  end

  defp print_string(key, _, true, ident, break_off_length) when is_binary(key) do
    ">\n#{ident}#{key}"
  end

  defp create_whitespace(number, spaces \\ "  ")
  defp create_whitespace(0, _spaces), do: ""

  defp create_whitespace(number, spaces) do
    String.duplicate(spaces, number)
  end
end
