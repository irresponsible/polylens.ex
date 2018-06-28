defmodule PolylensTest do
  use ExUnit.Case
  doctest Polylens
  alias Polylens.Lenses

  @sample {1, %{2 => [3, 4]}}
  @one   [Lenses.at_index(0)]
  @two   [Lenses.at_index(1), Lenses.key_at(2)]
  @three [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(0)]
  @four  [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(1)]
  @numbers_get [@one, @two, @three, @four]

  # Because we're ripping it all apart, some of the lenses become invalidated during transformation
  @three_set [Lenses.at_index(1), Lenses.at_key(42), Lenses.at_index(0)]
  @four_set  [Lenses.at_index(1), Lenses.at_key(42), Lenses.at_index(1)]
  @numbers_set [@one, @two, @three_set, @four_set]
  @three_update [Lenses.at_index(1), Lenses.at_key(3), Lenses.at_index(0)]
  @four_update  [Lenses.at_index(1), Lenses.at_key(3), Lenses.at_index(1)]
  @numbers_update [@one, @two, @three_update, @four_update]

  @getting_out [1, 2, 3, 4]
  @setting_out {42, %{42 => [42, 42]}}
  @updating_out {2, %{3 => [4, 5]}}

  test "getting" do
    assert @getting_out === Enum.map(@numbers_get, fn number ->
      {:ok, ret} = Polylens.get_in(number, @sample)
      ret
    end)
  end
  test "setting" do
    assert @setting_out ===
      Enum.reduce(@numbers_set, @sample, fn lens, data ->
    	{:ok, ret} = Polylens.set_in(lens, data, 42)
	ret
      end)
  end
  test "updating" do
    assert @updating_out ===
      Enum.reduce(@numbers_update, @sample, fn lens, data ->
    	{:ok, ret} = Polylens.update_in(lens, data, fn x -> x + 1 end)
    	ret
      end)
  end

end
