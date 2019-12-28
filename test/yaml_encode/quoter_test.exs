defmodule YamlEncode.QuoterTest do
  use ExUnit.Case
  import YamlEncode.Quoter, only: [quotes?: 1]

  @quotes [
    "1999-02-24",
    "test#test",
    "123",
    "123.456",
    "true",
    "null",
    "no",
    " test",
    "test ",
    "0x1234",
    "test[test]",
    "!test",
    "test:test",
    "12:15:30",
    "{test: [test]}"
  ]

  @no_quotes [
    "testing",
    "test123",
    "test-test",
    "test.test",
    "test<test>",
    "test test",
    "5e077e7f669d76b1422aff45",
    "+1 (950) 587-2562"
  ]

  test "quoter works, quotes" do
    Enum.each(@quotes, fn x ->
      assert quotes?(x)
    end)
  end

  test "quoter works, no quotes" do
    Enum.each(@no_quotes, fn x ->
      refute quotes?(x)
    end)
  end
end
