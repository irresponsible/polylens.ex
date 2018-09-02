# Polylens

An elixirified port of Haskell's lenses using multiple-dispatch polymorphism.

[Hexdocs](https://hexdocs.pm/polylens)

## Usage

```elixir
alias Polylens.Lenses

def sample, do: {1, %{2 => [3, 4]}}

# These lenses address each of the numbers
def one,   do: [Lenses.at_index(0)]
def two,   do: [Lenses.at_index(1), Lenses.key_at(2)]
def three, do: [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(0)]
def four,  do: [Lenses.at_index(1), Lenses.at_key(2), Lenses.at_index(1)]

def numbers, do: [four, three, two, one]

def example do

  # Firstly, we can get the values they lens over
  for number <- numbers do
    {:ok, num} = Polylens.get_in(number, sample)
    IO.inspect(num)
  end

  # We can set them all to the same thing. Result: {42, %{42 => [42, 42]}}
  Enum.reduce(numbers, sample, fn lens, data ->
    {:ok, ret} = Polylens.set_in(lens, data, 42)
    ret
  end
  |> IO.inspect()

  # We can modify them all. Result: {2, %{3 => [4, 5]}}
  Enum.reduce(numbers, sample, fn lens, data ->
    {:ok, ret} = Polylens.update_in(lens, data, fn x -> x + 1 end)
    ret
  end
  |> IO.inspect()

end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `polylens` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # ... other deps ...
    {:polylens, "~> 0.1.0"},
  ]
end
```

## Implementing your own lenses

We use [protocol_ex](https://github.com/OvermindDL1/protocol_ex) to fake
multiple dispatch with `{lens, data}` tuples via the `Lens` protocol_ex.

To build your own lenses, you will need to add
`:protocol_ex` to your Mix project compilers:

```elixir
def project do
  [
    ## ... other config ...
    ## Make sure [:protocol_ex] comes after :elixirc !
    compilers: Mix.compilers ++ [:protocol_ex],
  ]
end
```

You may then implement the `Lens` protocol_ex. Here is how we
implement `AtKey` for maps:

```elixir
import ProtocolEx
alias Polylens.Lens

defimpl_ex MapAtKey, {%Polylens.AtKey{},map} when is_map(map), for: Lens do
  def get({%{key: key}, map}) do
    fail = make_ref()
    case Map.get(map, key, fail) do
      ^fail -> {:error, :not_found}
      ret -> {:ok, ret}
    end
  end
  def set({%{key: key}, map}, value), do: {:ok, Map.put(map, key, value)}
end
```

## Note for Haskell/Purescript users

If you're familiar with haskell or purescript lenses, Polylens lenses
most closely represent 'at' lenses because owing to the dynamic nature
of Elixir, they may fail.

## Copyright and License

Copyright 2018 James Laver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
  
