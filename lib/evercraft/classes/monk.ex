defmodule Evercraft.Classes.Monk do
  use Evercraft.Class
  alias Evercraft.{ Ability, Attack, Character }

  def hit_point_bonus_from_level(%Character{} = character) do
    6 * Character.level(character)
  end

  def damage_bonus(%Attack{} = attack) do
    super(attack) + 2
  end

  def armor_class_bonus(%Attack{defender: defender} = attack) do
    super(attack) + (Character.wisdom(defender) |> Ability.modifier())
  end

  def attack_bonus_from_level(%Attack{attacker: attacker}) do
    level = Character.level(attacker)
    Enum.zip(1..level, Stream.cycle([0,1,1]))
    |> Enum.map(fn {_, bonus} -> bonus end)
    |> Enum.sum()
  end

end
