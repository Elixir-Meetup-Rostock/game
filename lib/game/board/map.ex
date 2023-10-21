defmodule Game.Board.Map do
  @moduledoc """
  Holds the data of the map
  """

  def get() do
    %{
      {0, 0} => "rock",
      {16, 0} => "rock",
      {32, 0} => "rock",
      {48, 0} => "rock",
      {64, 0} => "rock",
      {80, 0} => "rock",
      {96, 0} => "rock",
      {0, 16} => "rock",
      {16, 16} => "grass",
      {32, 16} => "grass",
      {48, 16} => "grass",
      {64, 16} => "grass",
      {80, 16} => "grass",
      {96, 16} => "rock",
      {0, 32} => "rock",
      {16, 32} => "grass",
      {32, 32} => "grass",
      {48, 32} => "grass_flowers",
      {64, 32} => "grass",
      {80, 32} => "grass",
      {96, 32} => "rock",
      {0, 48} => "rock",
      {16, 48} => "grass_flowers",
      {32, 48} => "grass",
      {48, 48} => "grass",
      {64, 48} => "grass",
      {80, 48} => "grass",
      {96, 48} => "rock",
      {0, 64} => "rock",
      {16, 64} => "grass",
      {32, 64} => "grass",
      {48, 64} => "grass",
      {64, 64} => "grass_flowers",
      {80, 64} => "grass",
      {96, 64} => "rock",
      {0, 80} => "rock",
      {16, 80} => "grass",
      {32, 80} => "grass",
      {48, 80} => "grass",
      {64, 80} => "grass",
      {80, 80} => "grass",
      {96, 80} => "rock",
      {0, 96} => "rock",
      {16, 96} => "rock",
      {32, 96} => "rock",
      {48, 96} => "rock",
      {64, 96} => "rock",
      {80, 96} => "rock",
      {96, 96} => "rock"
    }
  end
end
