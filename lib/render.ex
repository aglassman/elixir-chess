defmodule Chess.Render do
  import Chess

  @callback render(state :: Chess.state(), opts :: keyword()) :: binary()

end