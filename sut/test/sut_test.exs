defmodule SutTest do
  use ExUnit.Case
  doctest Sut
  import Sut

  data = [
    {1, 3, 4},
    {7, 4, 10}, # Error intencional
    {16, -4, 12},
    {-8, 6,-2},
    {-3, -5, -8}
  ]
  for {a,b,c} <- data do
    @a a
    @b b
    @c c
    test "sum of #{@a} and #{@b} should equal #{@c}" do  
      assert Sut.sum(@a,@b) == @c 
    end
  end
end
