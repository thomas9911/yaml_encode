defmodule YamlEncoder.Encoder do
  import YamlEncoder.Quoter, only: [quotes?: 1]

  def encode(map, n \\ 0) when is_map(map) do
    result = create_yaml(map, n)
    {:ok, result}
  end

  def create_yaml(map, 0) do
    Enum.reduce(map, "---\n", &reduce_yaml/2)
  end

  def create_yaml(map, n) do
    Enum.reduce(map, "", &reduce_yaml(&1, &2, n))
  end

  defp reduce_yaml(tuple, acc, n \\ 0)

  defp reduce_yaml({k, v}, acc, n) do
    k = convert_to_key(k, n)
    v = convert_to_value(v, n)

    convert_to_string({k, v}, acc)
  end

  def convert_to_string({k, v}, "---\n" = acc) do
    "#{acc}#{k}:#{v}"
  end

  def convert_to_string({k, v}, acc) do
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

  defp convert_to_value(true, _) do
    " true"
  end

  defp convert_to_value(false, _) do
    " false"
  end

  defp convert_to_value(value, _) when is_binary(value) do
    " #{print_quotes(value, quotes?(value))}"
  end

  defp convert_to_value(value, _) when is_number(value) do
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
