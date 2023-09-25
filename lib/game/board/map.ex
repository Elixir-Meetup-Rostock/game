defmodule Game.Board.Map do
  @moduledoc """
  Holds the data of the map
  """

  def get() do
    %{
      {0, 0} => "rock", {1, 0} => "rock", {2, 0} => "rock", {3, 0} => "rock", {4, 0} => "rock", {5, 0} => "rock", {6, 0} => "rock",
      {0, 1} => "rock", {1, 1} => "grass", {2, 1} => "grass", {3, 1} => "grass", {4, 1} => "grass", {5, 1} => "grass", {6, 1} => "rock",
      {0, 2} => "rock", {1, 2} => "grass", {2, 2} => "grass", {3, 2} => "grass", {4, 2} => "grass", {5, 2} => "grass", {6, 2} => "rock",
      {0, 3} => "rock", {1, 3} => "grass", {2, 3} => "grass", {3, 3} => "grass", {4, 3} => "grass", {5, 3} => "grass", {6, 3} => "rock", 
      {0, 4} => "rock", {1, 4} => "grass", {2, 4} => "grass", {3, 4} => "grass", {4, 4} => "grass", {5, 4} => "grass", {6, 4} => "rock",
      {0, 5} => "rock", {1, 5} => "grass", {2, 5} => "grass", {3, 5} => "grass", {4, 5} => "grass", {5, 5} => "grass", {6, 5} => "rock",
      {0, 6} => "rock", {1, 6} => "rock", {2, 6} => "rock", {3, 6} => "rock", {4, 6} => "rock", {5, 6} => "rock", {6, 6} => "rock"
    }
  end
end
