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

  For more examples check [the tests](#{Mix.Project.config()[:source_url]}/blob/master/test/yaml_encode_test.exs)

  """
  @spec encode(map | [map]) :: {:ok, binary} | {:error, binary}
  defdelegate encode(map), to: YamlEncode.Encoder
end
