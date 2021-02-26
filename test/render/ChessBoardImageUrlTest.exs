defmodule ChessBoardImageUrlTest do
  use ExUnit.Case

  test "Test basic URL creation" do
    assert Chess.Render.ChessBoardImageUrl.render(Chess.init()) ==
             "https://chessboardimage.com/rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
  end

end