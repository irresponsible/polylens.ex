defmodule Polylens.Lenses do
  alias Polylens.{KeyAt, AtKey, AtIndex}

  @doc "Constructor for KeyAt"
  def key_at(key), do: %KeyAt{key: key}

  @doc "Constructor for AtKey"
  def at_key(key), do: %AtKey{key: key}

  @doc "Constructor for AtIndex"
  def at_index(index), do: %AtIndex{index: index}

end
