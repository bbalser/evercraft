defmodule Evercraft.Attack do
  alias Evercraft.{ Character, Equipment }

  @type t :: %__MODULE__{}

  defstruct [:attacker, :defender, :roll]

  @spec new(Character.t, Character.t, integer) :: t
  def new(attacker, defender, roll) do
    %__MODULE__{attacker: attacker, defender: defender, roll: roll}
  end

  @spec hit?(t) :: boolean
  def hit?(%__MODULE__{defender: defender, roll: roll} = attack) do
    (roll + attack_bonus(attack)) >= (Character.armor_class(defender) + armor_class_bonus(attack))
  end

  @spec apply_damage(t) :: Character.t
  def apply_damage(%__MODULE__{defender: defender} = attack) do
    new_hitpoints = Character.hit_points(defender) - determine_damage(attack)
    Character.copy(defender, hit_points: new_hitpoints)
  end

  defp determine_damage(%__MODULE__{roll: roll} = attack) do
    case {hit?(attack), roll == 20}  do
      {true, true} -> (critical_hit_multiplier(attack) * (1 + damage_bonus(attack))) |> max(1)
      {true, false} -> (1 + damage_bonus(attack)) |> max(1)
      {false, _} -> 0
    end
  end

  defp attack_bonus(%__MODULE__{attacker: attacker} = attack) do
    Equipment.sum(attacker, :attack_bonus, [attack])
  end

  defp damage_bonus(%__MODULE__{attacker: attacker} = attack) do
    Equipment.sum(attacker, :damage_bonus, [attack])
  end

  defp armor_class_bonus(%__MODULE__{defender: defender} = attack) do
    Equipment.sum(defender, :armor_class_bonus, [attack])
  end

  defp critical_hit_multiplier(%__MODULE__{attacker: attacker} = attack) do
    Equipment.max(attacker, :critical_hit_multiplier, [attack])
  end

end
