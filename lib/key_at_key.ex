defmodule Polylens.KeyAtKey do
  @enforce_keys [:key]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.{Lens, KeyAtKey}

defimpl_ex MapKeyAtKey, {%KeyAtKey{},map} when is_map(map), for: Lens do
  def get({%{key: key}, map}) do
    fail = make_ref()
    case Map.get(map, key, fail) do
      ^fail -> {:error, :not_found}
      _ -> {:ok, key}
    end
  end
  def set({%{key: key}, map}, new_key) do
    fail = make_ref()
    case Map.get(map, key, fail) do
      ^fail -> {:error, :not_found}
      val ->
	ret = Map.delete(map, key)
	|> Map.assoc(new_key, val)
	{:ok, ret}
    end
  end
end

defimpl_ex ListKeyAtKey, {%KeyAtKey{},list} when is_list(list), for: Lens do
  def get({%{key: key}, list}) do
    fail = make_ref()
    case :proplists.get_value(key, list, fail) do
      ^fail -> {:error, :not_found}
      ret -> {:ok, ret}
    end
  end
  def set({%{key: key}, list}, key), do: {:ok, [ {key, key} | :proplists.delete(key, list) ]}
end
