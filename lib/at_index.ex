defmodule Polylens.AtIndex do
  @enforce_keys [:index]
  defstruct @enforce_keys
end

import ProtocolEx
alias Polylens.Lens

defimpl_ex ListAtIndex, {%Polylens.AtIndex{},list} when is_list(list), for: Lens do
  def get({%{index: index}, list}) do
    fail = make_ref()
    case Enum.at(list, index, fail) do
      ^fail -> {:error, :not_found}
      ret -> {:ok, ret}
    end
  end
  def set({%{index: index}, list}, value),
    do: {:ok, List.replace_at(list, index, value)}
end

defimpl_ex TupleAtIndex, {%Polylens.AtIndex{},tuple} when is_tuple(tuple), for: Lens do
  def get({%{index: index}, tuple}) do
    if tuple_size(tuple) > index,
      do: {:ok, elem(tuple, index)},
      else: {:error, :not_found}
  end
  def set({%{index: index}, tuple}, value) do
    if tuple_size(tuple) > index,
      do: {:ok, Tuple.insert_at(tuple, index, value)},
      else: {:error, :not_found}
  end
end
