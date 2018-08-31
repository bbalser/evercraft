defmodule Evercraft.Race.Orc do
  use Evercraft.Race

  def ability_bonus(:strength), do: 4
  def ability_bonus(:intelligence), do: -2
  def ability_bonus(:wisdom), do: -2
  def ability_bonus(:charisma), do: -2
  def ability_bonus(ability), do: super(ability)

  def armor_class_bonus_for_character(_character) do
    2
  end

end
