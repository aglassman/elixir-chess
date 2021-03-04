defmodule Chess.Render.UnicodeBoard do
  alias Chess.Render


  @unicode_map %{
    {:white, :pawn} => "♙",
    {:white, :rook} => "♖",
    {:white, :knight} => "♘",
    {:white, :bishop} => "♗",
    {:white, :queen} => "♕",
    {:white, :king} => "♔",
    {:black, :pawn} => "♟",
    {:black, :rook} => "♜",
    {:black, :knight} => "♞",
    {:black, :bishop} => "♝",
    {:black, :queen} => "♛",
    {:black, :king} => "♚",
    nil => " "
  }

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
    {:black, :king} => "k",
    nil => " "
  }

  @doc """
  options:

  """
  @impl Render
  def render(state, opts \\ []) do

    for rank <- 8..1, file <- 1..8 do
      piece = Map.get(state, {rank,file})
      unicode = Map.get(@fen_map, piece)
      "[#{unicode}]"
    end
    |> Enum.chunk_every(8)
    |> Enum.with_index()
    |> Enum.map(fn {row, rank} -> [ "#{8 - rank} " | row] |> Enum.join("") end)
    |> Enum.concat(["   a  b  c  d  e  f  g  h"])
    |> Enum.join("\n")

  end


end