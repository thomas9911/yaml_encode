defmodule YamlEncoder do
  # def encode(map) when is_map(map) do
  #   YamlEncoder.Encoder.map(map)
  # end
  defdelegate encode(map), to: YamlEncoder.Encoder
end
