defmodule Evercraft.Character do
  alias Evercraft.{Alignment, Equipment}

  @type t :: %__MODULE__{}

  defstruct name: nil,
            alignment: Alignment.neutral(),
            hit_points: nil,
            strength: 10,
            dexterity: 10,
            constitution: 10,
            wisdom: 10,
            intelligence: 10,
            charisma: 10,
            class: Evercraft.Class.Default,
            race: Evercraft.Race.Human,
            experience: 0

  @spec new(keyword) :: t
  def new(opts) do
    character = struct(__MODULE__, opts)

    case character.hit_points do
      nil -> %{character | hit_points: max_hit_points(character)}
      _ -> character
    end
  end

  @spec copy(t, keyword) :: t
  def copy(%__MODULE__{} = character, opts) do
    struct(character, opts)
  end

  @spec name(t) :: String.t()
  def name(%__MODULE__{name: name}), do: name

  @spec alignment(t) :: Alignment.t()
  def alignment(%__MODULE__{alignment: alignment}), do: alignment

  @spec armor_class(t) :: integer
  def armor_class(%__MODULE__{} = character) do
    10 + Equipment.sum(character, :armor_class_bonus_for_character)
  end

  @spec hit_points(t) :: integer
  def hit_points(%__MODULE__{hit_points: hit_points}), do: hit_points

  @spec max_hit_points(t) :: integer
  def max_hit_points(%__MODULE__{} = character) do
    Equipment.sum(character, :hit_point_bonus)
    |> max(1)
  end

  @spec alive?(t) :: boolean
  def alive?(%__MODULE__{hit_points: hit_points}) do
    hit_points > 0
  end

  def strength(%__MODULE__{} = character), do: ability_bonus(character, :strength)
  def dexterity(%__MODULE__{} = character), do: ability_bonus(character, :dexterity)
  def constitution(%__MODULE__{} = character), do: ability_bonus(character, :constitution)
  def wisdom(%__MODULE__{} = character), do: ability_bonus(character, :wisdom)
  def intelligence(%__MODULE__{} = character), do: ability_bonus(character, :intelligence)
  def charisma(%__MODULE__{} = character), do: ability_bonus(character, :charisma)

  @spec level(t) :: integer
  def level(%__MODULE__{experience: exp}) do
    1 + div(exp, 1000)
  end

  def equipped(%__MODULE__{class: class, race: race}) do
    [class, race]
  end

  defp ability_bonus(character, ability) do
    Map.get(character, ability) + Equipment.sum(character, :ability_bonus, [ability])
  end
end
