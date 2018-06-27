# Polylens

Polymorphic Lenses

## Usage

```elixir
alias Polylens.Lenses

def sample, do: {1, %{2 => [3, 4]}}

# These lenses address each of the numbers
def one,   do: [Lenses.value_at_index(0)]
def two,   do: [Lenses.value_at_index(1), Lenses.key_at_key(2)]
def three, do: [Lenses.value_at_index(1), Lenses.value_at_key(2), Lenses.value_at_index(0)]
def four,  do: [Lenses.value_at_index(1), Lenses.value_at_key(2), Lenses.value_at_index(1)]

def numbers, do: [one, two, three, four]

def example do

  # Firstly, we can get the values they lens over
  for number <- number do
    Polylens.get_in(number, sample)
    |> IO.inspect()
  end

  # We can set them all to the same thing. Result: {42, %{42 => [42, 42]}}
  Enum.reduce(numbers, sample, fn lens, data ->
    Polylens.set_in(lens, data, 42)
  end
  |> IO.inspect()

  # We can modify them all. Result: {2, %{3 => [4, 5]}}
  Enum.reduce(numbers, sample, fn lens, data ->
    Polylens.update_in(lens, data, fn x -> x + 1 end)
  end
  |> IO.inspect()

end
```

## Implementation

The lenses are all polymorphic via the `Lens` protocol_ex.

## Installation

Not yet available on hex.

If you are building your own lenses, you will need to add
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

<!-- If [available in Hex](https://hex.pm/docs/publish), the package can be installed -->
<!-- by adding `polylens` to your list of dependencies in `mix.exs`: -->

<!-- ```elixir -->
<!-- def deps do -->
<!--   [ -->
<!--     {:polylens, "~> 0.1.0"} -->
<!--   ] -->
<!-- end -->
<!-- ``` -->

<!-- Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc) -->
<!-- and published on [HexDocs](https://hexdocs.pm). Once published, the docs can -->
<!-- be found at [https://hexdocs.pm/polylens](https://hexdocs.pm/polylens). -->

