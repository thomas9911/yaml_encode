defmodule YamlEncode do
  @doc """
  Function that converts a map to a Yaml document

  ```
  iex> YamlEncode.encode(%{"test" => ["oke", 2]})
  {
    :ok,
    \"\"\"
    ---
    test:
      - oke
      - 2\\
    \"\"\"
  }
  ```
  """
  @spec encode(map | [map]) :: {:ok, binary} | {:error, binary}
  defdelegate encode(map), to: YamlEncode.Encoder
end
