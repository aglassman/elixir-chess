defmodule Chess.Render do

  @callback render(state :: Chess.state(), opts :: keyword()) :: binary()

end