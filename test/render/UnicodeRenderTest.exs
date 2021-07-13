defmodule UnicodeBoardTest do
  use ExUnit.Case

  test "Test unicode board at initial state: fen" do
   output = Chess.Render.UnicodeBoard.render(Chess.init())

   expected = """
    8 [r][n][b][q][k][b][n][r]
    7 [p][p][p][p][p][p][p][p]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][ ][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [P][P][P][P][P][P][P][P]
    1 [R][N][B][Q][K][B][N][R]
       a  b  c  d  e  f  g  h
    """ |> String.trim()

   assert expected == output
  end

  test "Test unicode board after move: fen" do
    state = Chess.init()
    |> Chess.move({{:white, :pawn}, {2,3}, {4,3}})

    output = Chess.Render.UnicodeBoard.render(state)

    expected = """
    8 [r][n][b][q][k][b][n][r]
    7 [p][p][p][p][p][p][p][p]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][P][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [P][P][ ][P][P][P][P][P]
    1 [R][N][B][Q][K][B][N][R]
       a  b  c  d  e  f  g  h
    """ |> String.trim()

    assert expected == output
  end

  test "Test unicode board at initial state: unicode" do
    output = Chess.Render.UnicodeBoard.render(Chess.init(), output: :unicode)

    expected = """
    8 [♜][♞][♝][♛][♚][♝][♞][♜]
    7 [♟][♟][♟][♟][♟][♟][♟][♟]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][ ][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [♙][♙][♙][♙][♙][♙][♙][♙]
    1 [♖][♘][♗][♕][♔][♗][♘][♖]
       a  b  c  d  e  f  g  h
    """ |> String.trim()

    assert expected == output
  end

  test "Test unicode board after move: unicode" do
    state = Chess.init()
            |> Chess.move({{:white, :pawn}, {2,3}, {4,3}})

    output = Chess.Render.UnicodeBoard.render(state, output: :unicode)

    expected = """
    8 [♜][♞][♝][♛][♚][♝][♞][♜]
    7 [♟][♟][♟][♟][♟][♟][♟][♟]
    6 [ ][ ][ ][ ][ ][ ][ ][ ]
    5 [ ][ ][ ][ ][ ][ ][ ][ ]
    4 [ ][ ][♙][ ][ ][ ][ ][ ]
    3 [ ][ ][ ][ ][ ][ ][ ][ ]
    2 [♙][♙][ ][♙][♙][♙][♙][♙]
    1 [♖][♘][♗][♕][♔][♗][♘][♖]
       a  b  c  d  e  f  g  h
    """ |> String.trim()

    assert expected == output
  end


end