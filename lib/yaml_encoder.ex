defmodule YamlEncode do
  # def encode(map) when is_map(map) do
  #   YamlEncode.Encoder.map(map)
  # end
  defdelegate encode(map), to: YamlEncode.Encoder
end
