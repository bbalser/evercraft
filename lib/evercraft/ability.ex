defmodule Evercraft.Ability do

  def modifier(ability_score) do
    Integer.floor_div(ability_score - 10, 2)
  end

end
