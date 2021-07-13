defmodule Chess.Notation.Unicode do
  alias Chess.Notation
  alias Chess.Render.UnicodeBoard

  @moduledoc """
  This module will take a string in the unicode notation below, and parse it into a game state.

  Example:
    8 [♜][♞][♝][♛][♚][♝][♞][♜]
    7 [♟][♟][♟][♟][♟][♟][♟][♟]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][ ][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [♙][♙][♙][♙][♙][♙][♙][♙]
    1 [♖][♘][♗][♕][♔][♗][♘][♖]
       a  b  c  d  e  f  g  h

  Note:
    Does not support move history, or current move.
  """

  @behaviour Notation

  @lookup %{
    " " => nil,
    "♔" => {:white, :king},
    "♕" => {:white, :queen},
    "♖" => {:white, :rook},
    "♗" => {:white, :bishop},
    "♘" => {:white, :knight},
    "♙" => {:white, :pawn},
    "♚" => {:black, :king},
    "♛" => {:black, :queen},
    "♜" => {:black, :rook},
    "♝" => {:black, :bishop},
    "♞" => {:black, :knight},
    "♟" => {:black, :pawn},
    "B" => {:white, :bishop},
    "K" => {:white, :king},
    "N" => {:white, :knight},
    "P" => {:white, :pawn},
    "Q" => {:white, :queen},
    "R" => {:white, :rook},
    "b" => {:black, :bishop},
    "k" => {:black, :king},
    "n" => {:black, :knight},
    "p" => {:black, :pawn},
    "q" => {:black, :queen},
    "r" => {:black, :rook}
  }

  @impl Notation
  def to_string(state, _opts \\ []) do
    """
    current move: #{state[:current]}
    #{UnicodeBoard.render(state, output: :fen)}
    """
  end

  @impl Notation
  def to_state(string, _opts \\ []) do
    state = Regex.scan(~r/[♜♞♝♛♚♟♖♘♗♕♔♙rnbqkpRNBQKP ](?=\])/, string)
    |> Enum.reverse()
    |> Enum.with_index(fn element, index -> {element, rem(index, 8) + 1} end)
    |> Enum.chunk_every(8)
    |> Enum.with_index(1)
    |> Enum.reduce(%{}, fn {rank, rank_index}, board_state ->
      Enum.reduce(rank, board_state, fn {[material], file_index}, rank_state ->
        case Map.get(@lookup, material) do
          nil -> rank_state
          position -> Map.put(rank_state,{rank_index, 9 - file_index}, position)
        end
      end)
    end)

   state
   |> Map.put(:current, :white)
   |> Map.put(:moves, [])
  end
end