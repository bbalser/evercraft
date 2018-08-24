defmodule Evercraft.Equipment do

  @callback attack_bonus(%Evercraft.Attack{}) :: integer
  @callback attack_bonus_from_level(%Evercraft.Attack{}) :: integer
  @callback attack_bonus_from_abilities(%Evercraft.Attack{}) :: integer

  @callback damage_bonus(%Evercraft.Attack{}) :: integer

  @callback armor_class_bonus(%Evercraft.Attack{}) :: integer

  @callback hit_point_bonus(%Evercraft.Character{}) :: integer
  @callback hit_point_bonus_from_level(%Evercraft.Character{}) :: integer
  @callback hit_point_bonus_from_abilities(%Evercraft.Character{}) :: integer

  @callback critical_hit_multiplier(%Evercraft.Attack{}) :: integer

  defmacro __using__(_opts) do
    quote do
      @behaviour Evercraft.Equipment

      def attack_bonus(%Evercraft.Attack{} = attack) do
        attack_bonus_from_level(attack) + attack_bonus_from_abilities(attack)
      end

      def attack_bonus_from_level(%Evercraft.Attack{}) do
        0
      end

      def attack_bonus_from_abilities(%Evercraft.Attack{}) do
        0
      end

      def damage_bonus(%Evercraft.Attack{}) do
        0
      end

      def armor_class_bonus(%Evercraft.Attack{}) do
        0
      end

      def hit_point_bonus(%Evercraft.Character{} = character) do
        hit_point_bonus_from_level(character) + hit_point_bonus_from_abilities(character)
      end

      def hit_point_bonus_from_level(%Evercraft.Character{}) do
        0
      end

      def hit_point_bonus_from_abilities(%Evercraft.Character{}) do
        0
      end

      def critical_hit_multiplier(%Evercraft.Attack{}) do
        0
      end

      defoverridable Evercraft.Equipment

    end
  end

  def sum(character, function) do
    sum(character, function, [character])
  end

  def sum(character, function, args) do
    Evercraft.Character.equipped(character)
    |> Enum.map(fn equipped -> apply(equipped, function, args) end)
    |> Enum.sum()
  end

  def max(character, function, args) do
    Evercraft.Character.equipped(character)
    |> Enum.map(fn equipped -> apply(equipped, function, args) end)
    |> Enum.max()
  end

end
