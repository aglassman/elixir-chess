defmodule Chess.Render.ChessBoardImageUrl do
  alias Chess.Render
  alias Chess.Notation.Fen

  @doc """
  options:

  """
  def render(state, opts \\ []) do

    fen = Fen.to_string(state)
    |> String.split(" ")
    |> List.first()

    "https://chessboardimage.com/#{fen}"
  end


end