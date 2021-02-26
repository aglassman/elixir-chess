defmodule ChessTest do
  use ExUnit.Case
  doctest Chess

  test "New game to FEN" do
    fen =
      Chess.init()
      |> Chess.Notation.Fen.to_string()

    assert fen == "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w"
  end

  test "New game to FEN with castle" do
    fen =
      Chess.init()
      |> Map.drop([{1, 6}, {1, 7}])
      |> IO.inspect()
      |> Chess.Notation.Fen.to_string()

    assert fen == "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQK2R w Q"
  end

  test "FEN to new game" do
    from_fen = Chess.Notation.Fen.to_state("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")

    assert from_fen == Chess.init()
  end
end
