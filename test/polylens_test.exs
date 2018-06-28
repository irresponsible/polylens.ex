defmodule PolylensTest do
  use ExUnit.Case
  doctest Polylens
  alias Polylens.Lenses

  @sample {1, %{2 => [3, 4]}}
  @one   [Lenses.at_index(0)]
  @two   [Lenses.at_index(1), Lenses.key_at(2)]
  @three [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(0)]
  @four  [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(1)]
  @numbers [@four, @three, @two, @one]

  @getting_out [4, 3, 2, 1]
  @setting_out {42, %{42 => [42, 42]}}
  @updating_out {2, %{3 => [4, 5]}}

  test "getting" do
    assert @getting_out === Enum.map(@numbers, fn number ->
      {:ok, ret} = Polylens.get_in(number, @sample)
      ret
    end)
  end
  test "setting" do
    assert @setting_out ===
      Enum.reduce(@numbers, @sample, fn lens, data ->
    	{:ok, ret} = Polylens.set_in(lens, data, 42)
	ret
      end)
  end
  test "updating" do
    assert @updating_out ===
      Enum.reduce(@numbers, @sample, fn lens, data ->
    	{:ok, ret} = Polylens.update_in(lens, data, fn x -> x + 1 end)
    	ret
      end)
  end

end
