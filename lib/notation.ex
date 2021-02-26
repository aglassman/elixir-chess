defmodule Chess.Notation do
  import Chess

  @callback to_string(Chess.state()) :: String.t()

  @callback to_state(String.t()) :: Chess.state()
end
