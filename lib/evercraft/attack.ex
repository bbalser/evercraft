defmodule Evercraft.Attack do

  alias Evercraft.Character

  defstruct [:attacker, :defender, :roll]

  def new(attacker, defender, roll) do
    %__MODULE__{attacker: attacker, defender: defender, roll: roll}
  end

  def hit?(%__MODULE__{defender: defender, roll: roll} = attack) do
    (roll + attack_bonus(attack)) >= Character.armor_class(defender)
  end

  def apply_damage(%__MODULE__{defender: defender} = attack) do
    new_hitpoints = Character.hit_points(defender) - determine_damage(attack)
    Character.copy(defender, hit_points: new_hitpoints)
  end

  defp determine_damage(%__MODULE__{roll: roll} = attack) do
    case {hit?(attack), roll == 20}  do
      {true, true} -> 2 * (1 + damage_bonus(attack)) |> max(1)
      {true, false} -> 1 + damage_bonus(attack) |> max(1)
      {false, _} -> 0
    end
  end

  defp attack_bonus(%__MODULE__{attacker: attacker} = attack) do
    Character.equipped(attacker)
    |> Enum.map(fn equipped -> equipped.attack_bonus(attack) end)
    |> Enum.sum()
  end

  defp damage_bonus(%__MODULE__{attacker: attacker} = attack) do
    Character.equipped(attacker)
    |> Enum.map(fn equipped -> equipped.attack_bonus(attack) end)
    |> Enum.sum()
  end

end

