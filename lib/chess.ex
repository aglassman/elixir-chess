defmodule Chess do
  @type color() :: :black | :white
  @type piece() :: {color(), :pawn | :rook | :knight | :bishop | :queen | :queen}
  @type position() :: {rank :: 1..8, file :: 1..8}
  @type move() :: {piece(), to :: position(), from :: position()}
  @type piece_position() :: {position(), piece()}

  @type state() :: %{
          :current => color(),
          :moves => [move()],
          position() => piece()
        }

  @material [
    {:pawn, Enum.map(1..8, &{2, &1})},
    {:rook, [{1, 1}, {1, 8}]},
    {:knight, [{1, 2}, {1, 7}]},
    {:bishop, [{1, 3}, {1, 6}]},
    {:queen, [{1, 4}]},
    {:king, [{1, 5}]}
  ]

  @colors [:black, :white]

  @defmodule """
  Game state is represented by a map defined by the state() type. Values include:

    location:
    {rank, file} => {color, piece}

    current move:
    :current => color

    previous moves:
    :moves => [{{color, piece}, {rank, file} = from, {rank, file} = to}, ... ]

  Example:
  %{
    :current => :white
    :moves => [{{:white, :pawn}, {2,1}, {2,4}}]
    {1, 1} => {:white, :rook},
    {8, 3} => {:black, :bishop},
    ...
  }

  Map is sparse, so only spaces with a piece are tracked in the state.
  """

  @doc """
  Will initialize with the given options:

  current, type: color() - The color who's turn it is to move.
  board, type: piece_position() - List of current piece locations on the board.
  moves, type: [move()] - List of past moves.
  """
  @spec init(keyword()) :: state()
  def init(opts \\ [])

  def init([]) do
    for color <- @colors, {piece, locations} <- @material do
      for {rank, file} <- locations do
        case {{rank, file}, {color, piece}} do
          {_, {:black, _}} -> {{9 - rank, file}, {color, piece}}
          position -> position
        end
      end
    end
    |> List.flatten()
    |> Map.new()
    |> Map.put(:current, :white)
    |> Map.put(:moves, [])
  end

  def init(opts) do
    current = Keyword.get(opts, :current, :white)
    board = Keyword.get(opts, :board, [])
    moves = Keyword.get(opts, :moves, [])

    Map.merge(
      %{
        current: current,
        moves: moves
      },
      Map.new(board)
    )
  end

  @doc """
  Attempt to apply the specified move to the given game state.
  """
  @spec move(state(), move()) :: state() | {:error, string()}
  def move(%{current: color} = state, move) do
    with {:ok, move} <- validate_move(state, move) do
      state
      |> move_piece(move)
      |> next_player()
    else
      message -> {:error, message}
    end
  end

  def move(_, _) do
    {:error, "invalid move"}
  end

  def validate_move(state, {material, from, to} = move) do
    with :ok <- validate_turn(state, material),
         {:location, ^material} <- {:location, Map.get(state, from)},
         {:ok, move} <- valid_piece_movement(state, move) do
      {:ok, move}
    else
      {:location, nil} -> "Requested #{inspect(move)}, but no piece found at #{inspect(from)}."
      {:location, found} -> "Requested #{inspect(material)}, but found #{inspect(found)} instead."
      {:invalid_move, invalid} -> "Invalid move: #{invalid}"
    end
  end

  defp validate_turn(%{current: color}, {color, _}) do
    :ok
  end

  defp validate_turn(%{current: current_color}, _) do
    {:current, "It's #{current_color}'s turn."}
  end

  defp move_piece(state, {material, from, to} = move) do
    state
    |> Map.drop([from])
    |> Map.put(to, material)
    |> Map.update!(:moves, &[move | &1])
  end

  defp next_player(%{current: :black} = state), do: %{state | current: :white}
  defp next_player(state), do: %{state | current: :black}

  ### Pawn Movement
  # Opening moves
  def valid_piece_movement(
        state,
        {{:black, :pawn} = piece, {7, file}, {to_rank, file} = to} = move
      )
      when (7 - to_rank) in [1, 2] do
    case Map.get(state, to) do
      nil ->
        {:ok, move}

      blocking_piece ->
        {:invalid_move,
         "Cannot move #{inspect(piece)} to #{inspect(to)} because #{inspect(blocking_piece)} is blocking."}
    end
  end

  def valid_piece_movement(
        state,
        {{:white, :pawn} = piece, {2, file}, {to_rank, file} = to} = move
      )
      when (to_rank - 2) in [1, 2] do
    case Map.get(state, to) do
      nil ->
        {:ok, move}

      blocking_piece ->
        {:invalid_move,
         "Cannot move #{inspect(piece)} to #{inspect(to)} because #{inspect(blocking_piece)} is blocking."}
    end
  end

  # Subsuquent Moves
  def valid_piece_movement(
        state,
        {{:black, :pawn} = piece, {from_rank, file}, {to_rank, file} = to} = move
      )
      when from_rank - to_rank == 1 do
    case Map.get(state, to) do
      nil ->
        {:ok, move}

      blocking_piece ->
        {:invalid_move,
         "Cannot move #{inspect(piece)} to #{inspect(to)} because #{inspect(blocking_piece)} is blocking."}
    end
  end

  def valid_piece_movement(
        state,
        {{:white, :pawn} = piece, {from_rank, file}, {to_rank, file} = to} = move
      )
      when to_rank - from_rank == 1 do
    case Map.get(state, to) do
      nil ->
        {:ok, move}

      blocking_piece ->
        {:invalid_move,
         "Cannot move #{inspect(piece)} to #{inspect(to)} because #{inspect(blocking_piece)} is blocking."}
    end
  end

  # Castling
  def valid_piece_movement(state, {{:white, :king}, {1, 5}, {1, 3}} = move) do
    with :ok <- validate_castle(state, :white, {1, 1}, [{1, 2}, {1, 3}, {1, 4}]) do
      {:ok, move}
    end
  end

  def valid_piece_movement(state, {{:white, :king}, {1, 5}, {1, 7}} = move) do
    with :ok <- validate_castle(state, :white, {1, 8}, [{1, 6}, {1, 7}]) do
      {:ok, move}
    end
  end

  def valid_piece_movement(state, {{:black, :king}, {8, 5}, {8, 3}} = move) do
    with :ok <- validate_castle(state, :black, {8, 1}, [{8, 2}, {8, 3}, {8, 4}]) do
      {:ok, move}
    end
  end

  def valid_piece_movement(state, {{:black, :king}, {8, 5}, {8, 7}} = move) do
    with :ok <- validate_castle(state, :black, {8, 8}, [{8, 6}, {8, 7}]) do
      {:ok, move}
    end
  end

  def valid_piece_movement(_, move) do
    {:current, "invalid movement: #{inspect(move)}"}
  end

  def in_check(state, color) do
    {:check, nil}
  end

  defp validate_castle(state, color, rook_start, path) do
    with {:moved, nil} <- {:moved, first_move(state, color, :king)},
         {:moved, nil} <- {:moved, first_move(state, color, :rook, rook_start)},
         {:path, nil} <- {:path, Enum.find(path, &Map.has_key?(state, &1))},
         {:check, nil} <- in_check(state, :white) do
      :ok
    else
      {:moved, move} ->
        {:invalid_move, "The king has moved previously, and cannot castle. #{inspect(move)}"}

      {:path, blocked} ->
        {:invalid_move, "The castling path is blocked by #{inspect(blocked)}."}

      {:check, threat} ->
        {:invalid_move, "The king is under threat by #{inspect(threat)}, and cannot castle."}
    end
  end

  defp first_move(%{moves: moves}, color, piece) do
    Enum.find(
      moves,
      fn
        {{^color, ^piece}, _, _} -> true
        _ -> nil
      end
    )
  end

  defp first_move(%{moves: moves}, color, piece, from) do
    Enum.find(
      moves,
      fn
        {{^color, ^piece}, ^from, _} -> true
        _ -> nil
      end
    )
  end
end
