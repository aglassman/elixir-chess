defmodule Chess.Notation.Fen do
  alias Chess.Notation

  @behaviour Notation

  @fen_map %{
    {:white, :pawn} => "P",
    {:white, :rook} => "R",
    {:white, :knight} => "N",
    {:white, :bishop} => "B",
    {:white, :queen} => "Q",
    {:white, :king} => "K",
    {:black, :pawn} => "p",
    {:black, :rook} => "r",
    {:black, :knight} => "n",
    {:black, :bishop} => "b",
    {:black, :queen} => "q",
    {:black, :king} => "k"
  }

  defp positions(state) do
    for rank <- 8..1, file <- 1..8 do
      {rank, file}
    end
    |> Enum.map(&Map.get(state, &1))
    |> Enum.map(&Map.get(@fen_map, &1))
    |> Enum.chunk_every(8)
    |> Enum.map(fn rank ->
      Enum.reduce(
        rank,
        {"", 0},
        fn
          nil, {fen, 7} -> {"#{fen}8", 0}
          nil, {fen, spaces} -> {fen, spaces + 1}
          peice, {fen, 0} -> {"#{fen}#{peice}", 0}
          peice, {fen, spaces} -> {"#{fen}#{spaces}#{peice}", 0}
        end
      )
    end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.join("/")
  end

  defp active_color(%{current: :black}), do: "b"
  defp active_color(%{current: :white}), do: "w"

  defp castle(state) do
    ["K", "Q", "k", "q"]
    |> Enum.filter(&match?({:ok, _}, check_castle(state, &1)))
    |> Enum.join("")
  end

  defp check_castle(state, "K"),
    do: Chess.valid_piece_movement(state, {{:white, :king}, {1, 5}, {1, 3}}) |> IO.inspect()

  defp check_castle(state, "Q"),
    do: Chess.valid_piece_movement(state, {{:white, :king}, {1, 5}, {1, 7}}) |> IO.inspect()

  defp check_castle(state, "k"),
    do: Chess.valid_piece_movement(state, {{:black, :king}, {8, 5}, {8, 7}}) |> IO.inspect()

  defp check_castle(state, "q"),
    do: Chess.valid_piece_movement(state, {{:black, :king}, {8, 5}, {8, 3}}) |> IO.inspect()

  @impl Notation
  def to_string(state) do
    [positions(state), active_color(state), castle(state)]
    |> Enum.join(" ")
    |> String.trim()
  end

  @impl Notation
  def to_state(string) do
    inverted_map = Map.new(@fen_map, fn {piece, fen} -> {fen, piece} end)

    board = string
    |> String.graphemes()
    |> Enum.reject(&(&1 == "/"))
    |> Enum.flat_map(fn fen ->
      case Map.get(inverted_map, fen) do
        nil -> for n <- 1..String.to_integer(fen), do: nil
        piece -> [piece]
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {fen, index} -> {fen, rem(index, 8)} end)
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.reduce([],fn {row, rank}, acc -> [Enum.map(row, fn {piece, file} -> {{8 - rank, 1 + file}, piece} end) | acc] end)
    |> List.flatten()
    |> Enum.reject(fn {_, piece} -> is_nil(piece) end)

    Chess.init(board: board)
  end
end
