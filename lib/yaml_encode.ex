defmodule YamlEncode do
  defdelegate encode(map), to: YamlEncode.Encoder
end
