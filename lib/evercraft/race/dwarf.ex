defmodule Evercraft.Race.Dwarf do
  use Evercraft.Race

  def ability_bonus(:constitution), do: 2
  def ability_bonus(:charisma), do: -2
  def ability_bonus(_), do: 0

end
