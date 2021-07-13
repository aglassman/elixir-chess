defmodule UnicodeTest do
  use ExUnit.Case

  test "Test unicode notation parser." do
   initial_state = Chess.init()
   output = Chess.Notation.Unicode.to_string(initial_state)
   parsed_state = Chess.Notation.Unicode.to_state(output)

   assert initial_state == parsed_state
  end

end