defmodule Evercraft.Character do

  alias Evercraft.{Ability, Alignment}

  defstruct [
    name: nil,
    alignment: Alignment.neutral,
    hit_points: nil,
    strength: 10,
    dexterity: 10,
    constitution: 10,
    wisdom: 10,
    intelligence: 10,
    charisma: 10,
    class: Evercraft.Classes.Default
  ]

  def new(opts) do
    character = struct(__MODULE__, opts)
    case character.hit_points do
      nil -> %{ character | hit_points: max_hit_points(character)}
      _ -> character
    end
  end

  def copy(%__MODULE__{} = character, opts) do
    struct(character, opts)
  end

  def name(%__MODULE__{name: name}), do: name

  def alignment(%__MODULE__{alignment: alignment}), do: alignment

  def armor_class(%__MODULE__{dexterity: dexterity} = _character), do: 10 + Ability.modifier(dexterity)

  def hit_points(%__MODULE__{hit_points: hit_points}), do: hit_points

  def max_hit_points(%__MODULE__{constitution: constitution}) do
    (5 + Ability.modifier(constitution)) |> max(1)
  end

  def alive?(%__MODULE__{hit_points: hit_points}) do
    hit_points > 0
  end

  def strength(%__MODULE__{strength: strength}), do: strength
  def dexterity(%__MODULE__{dexterity: dexterity}), do: dexterity
  def constitution(%__MODULE__{constitution: constitution}), do: constitution
  def wisdom(%__MODULE__{wisdom: wisdom}), do: wisdom
  def intelligence(%__MODULE__{intelligence: intelligence}), do: intelligence
  def charisma(%__MODULE__{charisma: charisma}), do: charisma

  def equipped(%__MODULE__{class: class}) do
    [class]
  end

end
