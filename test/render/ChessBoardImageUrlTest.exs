defmodule ChessBoardImageUrlTest do
  use ExUnit.Case

  test "Test basic URL creation" do
    assert Chess.Render.ChessBoardImageUrl.render(Chess.init()) ==
             "https://chessboardimage.com/rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR.png"
  end

  test "Test URL creation with last move" do
    state = Chess.init()
    |> Chess.move({{:white, :pawn}, {2,3}, {4,3}})

    assert Chess.Render.ChessBoardImageUrl.render(state, show_last_move: true) ==
             "https://chessboardimage.com/rnbqkbnr/pppppppp/8/8/2P5/8/PP1PPPPP/RNBQKBNR-c4c2.png"
  end


end