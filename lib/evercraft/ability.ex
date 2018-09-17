defmodule Evercraft.Ability do

  @spec modifier(integer) :: integer
  def modifier(ability_score) do
    Integer.floor_div(ability_score - 10, 2)
  end

end
