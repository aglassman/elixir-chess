defmodule Chess.Notation do

  @callback to_string(Chess.state(), opts :: keyword()) :: String.t()

  @callback to_state(String.t(), opts :: keyword()) :: Chess.state()
end
