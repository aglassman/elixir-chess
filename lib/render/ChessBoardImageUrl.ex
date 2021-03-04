defmodule Chess.Render.ChessBoardImageUrl do
  alias Chess.Render
  alias Chess.Notation.Fen

  @doc """
  options:
  show_last_move: boolean() - Will hilight the last move.
  """
  @impl Render
  def render(state, opts \\ []) do

    last_move = case Keyword.get(opts, :show_last_move) do
      nil -> ""
      _ -> last_move(state)
    end

    fen = Fen.to_string(state)
    |> String.split(" ")
    |> List.first()

    "https://chessboardimage.com/#{fen}#{last_move}.png"
  end

  defp last_move(%{moves: [{piece, {to_rank, to_file}, {from_rank, from_file}} | _]}) do
    "-#{Chess.file(from_file)}#{from_rank}#{Chess.file(to_file)}#{to_rank}"
  end

  defp last_move(_), do: ""
end