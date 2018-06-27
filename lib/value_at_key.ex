defmodule Polylens.ValueAtKey do
  @enforce_keys [:key]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.{Lens, ValueAtKey}

defimpl_ex MapValueAtKey, {%ValueAtKey{},map} when is_map(map), for: Lens do
  def get({%{key: key}, map}) do
    fail = make_ref()
    case Map.get(map, key, fail) do
      ^fail -> {:error, :not_found}
      ret -> {:ok, ret}
    end
  end
  def set({%{key: key}, map}, value), do: {:ok, Map.put(map, key, value)}
end

defimpl_ex ListValueAtKey, {%ValueAtKey{},list} when is_list(list), for: Lens do
  def get({%{key: key}, list}) do
    fail = make_ref()
    case :proplists.get_value(key, list, fail) do
      ^fail -> {:error, :not_found}
      ret -> {:ok, ret}
    end
  end
  def set({%{key: key}, list}, value), do: {:ok, [ {key, value} | list ] }
end
