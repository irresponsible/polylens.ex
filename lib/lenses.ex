defmodule Polylens.Lenses do
  alias Polylens.{KeyAtKey, ValueAtKey, ValueAtIndex}

  @doc "Constructor for a KeyAtKey"
  def key_at_key(key), do: %KeyAtKey{key: key}

  @doc "Constructor for a ValueAtKey"
  def value_at_key(key), do: %ValueAtKey{key: key}

  @doc "Constructor for a ValueAtIndex"
  def value_at_index(index), do: %ValueAtIndex{index: index}

end
