defmodule YamlEncoder.Quoter do
  # link: https://github.com/chyh1990/yaml-rust/blob/360a34d75bb64357cfdbc5bb706bcde9a0ecbc23/src/emitter.rs#L296

  @reserved_keys [
    # boolean
    "yes",
    "Yes",
    "YES",
    "no",
    "No",
    "NO",
    "True",
    "TRUE",
    "true",
    "False",
    "FALSE",
    "false",
    "on",
    "On",
    "ON",
    "off",
    "Off",
    "OFF",
    # null
    "null",
    "Null",
    "NULL",
    "~"
  ]
  # invalid_chars = [?:, ?{, ?}, ?[, ?], ?,, ?#, ?`, ?\", ?\', ?\\, ?\t, ?\n, ?\r] ++
  #   Enum.to_list(0..6) ++ Enum.to_list(14..26) ++ Enum.to_list(28..31)
  # invalid_binary = Enum.map(invalid_chars, fn x -> <<x :: utf8>> end)
  @invalid_binary [
    ":",
    "{",
    "}",
    "[",
    "]",
    ",",
    "#",
    "`",
    "\"",
    "'",
    "\\",
    "\t",
    "\n",
    "\r",
    <<0>>,
    <<1>>,
    <<2>>,
    <<3>>,
    <<4>>,
    <<5>>,
    <<6>>,
    <<14>>,
    <<15>>,
    <<16>>,
    <<17>>,
    <<18>>,
    <<19>>,
    <<20>>,
    <<21>>,
    <<22>>,
    <<23>>,
    <<24>>,
    <<25>>,
    <<26>>,
    <<28>>,
    <<29>>,
    <<30>>,
    <<31>>
  ]
  @invalid_start_chars [
    " ",
    "&",
    "*",
    "?",
    ",",
    "-",
    "<",
    ">",
    "=",
    "!",
    "%",
    "@",
    "."
  ]

  def quotes?(binary) when is_binary(binary) do
    reducer(
      [
        :reserved_string?,
        :integer?,
        :float?,
        :date?,
        :starts_with_specific_char?,
        :ends_with_specific_char?,
        :starts_with?,
        :contains?
      ],
      binary
    )
  end

  def integer?(binary) do
    case Integer.parse(binary, 10) do
      {_, ""} -> true
      {_, _} -> false
      _ -> false
    end
  end

  def float?(binary) do
    case Float.parse(binary) do
      {_, ""} -> true
      {_, _} -> false
      _ -> false
    end
  end

  def date?(binary) do
    case Date.from_iso8601(binary) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  def starts_with_specific_char?(binary)
      when binary_part(binary, 0, 1) in @invalid_start_chars do
    true
  end

  def starts_with_specific_char?(_), do: false

  def ends_with_specific_char?(binary) do
    pattern = [" "]

    String.ends_with?(binary, pattern)
  end

  def starts_with?(binary) do
    String.starts_with?(binary, :binary.compile_pattern(["0x"]))
  end

  def contains?(binary) do
    String.contains?(binary, :binary.compile_pattern(@invalid_binary))
  end

  def reserved_string?(binary)
      when binary in @reserved_keys,
      do: true

  def reserved_string?(_), do: false

  defp reducer(list_of_functions, binary_to_test) do
    Enum.reduce_while(
      list_of_functions,
      false,
      fn f, _ ->
        __MODULE__
        |> apply(f, [binary_to_test])
        |> boolean_to_halt()
      end
    )
  end

  defp boolean_to_halt(true), do: {:halt, true}
  defp boolean_to_halt(false), do: {:cont, false}
end
