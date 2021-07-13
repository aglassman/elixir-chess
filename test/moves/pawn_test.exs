defmodule PawnTest do
  use ExUnit.Case

  test "Test Opening Moves Valid" do
    state = Chess.init()
    for file <- 1..8, distance <- 1..2 do
      assert {:ok, {{:white, :pawn}, {2, file}, {2 + distance, file}}}
             == Chess.valid_piece_movement(state,{{:white, :pawn}, {2, file}, {2 + distance, file}})

      assert {:ok, {{:black, :pawn}, {7, file}, {7 - distance, file}}}
             == Chess.valid_piece_movement(state,{{:black, :pawn}, {7, file}, {7 - distance, file}})
    end
  end

#  test "Test Pawn Capture" do
#    state = Chess.init()
#
#  end

  test "Test Pawn Capture - Valid En Passant" do
    state = Chess.init(
      board: [{{5,5}, {:white, :pawn}},{{5,6}, {:black, :pawn}}],
      moves: [{{:black, :pawn}, {7,6}, {5,6}}]
    )

    IO.inspect(state)

    assert {:ok, _} = Chess.valid_piece_movement(state, {{:white, :pawn}, {5,5}, {6,6}})
  end

#  test "Test Pawn Capture - Invalid En Passant" do
#    state = Chess.init()
#
#  end
#
#  test "Test invalid Pawn Movements" do
#    state = Chess.init()
#
#  end
end
