defmodule Polylens.Lenses do
  @moduledoc """
  Functions for constructing the builtin lenses.
  """
  alias Polylens.{KeyAt, AtKey, AtIndex}

  @doc "Constructor for KeyAt. Takes a key"
  def key_at(key), do: %KeyAt{key: key}

  @doc "Constructor for AtKey. Takes a key"
  def at_key(key), do: %AtKey{key: key}

  @doc "Constructor for AtIndex. Takes an index"
  def at_index(index) when is_integer(index), do: %AtIndex{index: index}

end
