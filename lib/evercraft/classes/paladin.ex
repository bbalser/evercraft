defmodule Evercraft.Classes.Paladin do
  use Evercraft.Class

  alias Evercraft.{Attack, Character}

  def hit_point_bonus_from_level(%Character{} = character) do
    8 * Character.level(character)
  end

  def attack_bonus(%Attack{defender: defender} = attack) do
    bonus = if is_evil?(defender), do: 2, else: 0
    super(attack) + bonus
  end

  def critical_hit_multiplier(%Attack{defender: defender} = attack) do
    if is_evil?(defender), do: 3, else: super(attack)
  end

  def attack_bonus_from_level(%Attack{attacker: attacker}) do
    Character.level(attacker)
  end

  defp is_evil?(character) do
    Character.alignment(character) == :evil
  end

end
