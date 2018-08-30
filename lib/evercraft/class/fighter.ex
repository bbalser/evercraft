defmodule Evercraft.Class.Fighter do
  use Evercraft.Class
  alias Evercraft.{ Ability, Character }

  def attack_bonus_from_level(%Attack{attacker: attacker}) do
    Character.level(attacker)
  end

  def hit_point_bonus_from_level(%Character{} = character) do
    10 * Character.level(character)
  end

end
