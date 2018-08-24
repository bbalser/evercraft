defmodule Evercraft.Classes.Rogue do
  use Evercraft.Class

  alias Evercraft.{ Ability, Attack, Character }

  def critical_hit_multiplier(_attack) do
    3
  end

  def attack_bonus_from_abilities(%Attack{defender: defender} = attack) do
    super(attack) +
      (Character.dexterity(defender) |> Ability.modifier() |> max(0))
  end

end