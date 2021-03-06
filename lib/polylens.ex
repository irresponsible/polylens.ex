defmodule Polylens do
  @moduledoc """
  Functions for using Polylenses to manipulate and query data
  """
  import ProtocolEx
  import Kernel, except: [get_in: 2, update_in: 3]

  defprotocol_ex Lens do
    @moduledoc """
    The protocol_ex around which Polylens is based.
    Uses 2-tuples to fake multiple dispatch
    """
    # @type lens() :: term()
    # @spec get({lens(), term()}) :: {:ok, term()} | {:error, term()}
    @doc """
    Gets an item within the data
    """
    def get({lens, data})

    # @spec set({lens(), term()}, term()) :: {:ok, term()} | {:error, term()}
    @doc """
    Sets an item within the data
    """
    def set({lens, data}, value)

    # @spec update({lens(), term()}, (term() -> term())) :: {:ok, term()} | {:error, term()}
    @doc """
    Updates an item within the data with the provided function
    """
    def update(self, func) do
      with {:ok, val} <- get(self),
        do: set(self, func.(val))
    end
  end

  alias Polylens.Lens

  @doc "Gets an item within the data"
  def get(lens, data), do: Lens.get({lens, data})

  @doc "Sets an item within the data"
  def set(lens, data, value), do: Lens.set({lens, data}, value)

  @doc "Updates an item within the data with the provided function"
  def update(lens, data, func), do: Lens.update({lens, data}, func)

  @doc "Like get, but returns the untupled value or throws"
  def get!(lens, data) do
    {:ok, ret} = get(lens, data)
    ret
  end
  @doc "Like set, but returns the untupled value or throws"
  def set!(lens, data, value) do
    {:ok, ret} = set(lens, data, value)
    ret
  end
  @doc "Like update, but returns the untupled value or throws"
  def update!(lens, data, value) do
    {:ok, ret} = update(lens, data, value)
    ret
  end

  @doc "Like get, but takes a list of lenses to get nested data"
  def get_in(lenses, data) do
    ret = Enum.reduce_while(lenses, data, fn lens, data ->
      case get(lens, data) do
	{:ok, data} -> {:cont, data}
	r -> {:halt, r}
      end
    end)
    case ret do
      err = {:error, _} -> err
      other -> {:ok, other}
    end
  end

  @doc "Like set, but takes a list of lenses to set nested data"
  def set_in(lenses, data, value), do: set_in_h_in(lenses, [], data, value)

  defp set_in_h_in([], path, _, value), do: set_in_h_out(path, value)
  defp set_in_h_in([lens | lenses], path, data, value) do
    case get(lens, data) do
      {:ok, new_data} -> set_in_h_in(lenses, [ {lens, data} | path ], new_data, value)
      {:error, reason} -> {:error, {reason, path}}
    end
  end
  defp set_in_h_out([], value), do: {:ok, value}
  defp set_in_h_out([ {lens, data} | path ], value) do
    case set(lens, data, value) do
      {:ok, val} -> set_in_h_out(path, val)
      {:error, reason} -> {:error, {reason, path}}
    end
  end

  @doc "Like update, but takes a list of lenses to update nested data"
  def update_in(lenses, data, func), do: update_in_h_in(lenses, [], data, func)

  defp update_in_h_in([], path, data, func), do: set_in_h_out(path, func.(data))
  defp update_in_h_in([lens | lenses], path, data, func) do
    case get(lens, data) do
      {:ok, new_data} -> update_in_h_in(lenses, [ {lens, data} | path ], new_data, func)
      {:error, reason} -> {:error, {reason, path}}
    end
  end

  @doc "Like get_in, but returns untupled and throws if not ok"
  def get_in!(lenses, data) do
    {:ok, ret} = get_in(lenses, data)
    ret
  end

  @doc "Like set_in, but returns untupled and throws if not ok"
  def set_in!(lenses, data, value) do
    {:ok, ret} = set_in(lenses, data, value)
    ret
  end

  @doc "Like update, but returns untupled and throws if not ok"
  def update_in!(lenses, data, value) do
    {:ok, ret} = update_in(lenses, data, value)
    ret
  end

end

