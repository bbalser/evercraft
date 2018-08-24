defmodule Evercraft.Class do

  defmacro __using__(_opts) do
    quote do
      use Evercraft.Equipment
      alias Evercraft.{ Ability, Attack, Character }

      def attack_bonus_from_level(%Attack{attacker: attacker}) do
        div(Character.level(attacker), 2)
      end

      def attack_bonus_from_abilities(%Attack{attacker: attacker}) do
        Character.strength(attacker) |> Ability.modifier()
      end

      def damage_bonus(%Attack{attacker: attacker}) do
        Character.strength(attacker) |> Ability.modifier()
      end

      def armor_class_bonus(%Attack{defender: defender}) do
        Character.dexterity(defender) |> Ability.modifier()
      end

      def hit_point_bonus_from_level(%Character{} = character) do
        5 * Character.level(character)
      end

      def hit_point_bonus_from_abilities(%Character{} = character) do
        (Character.constitution(character) |> Ability.modifier()) * Character.level(character)
      end

      def critical_hit_multiplier(%Attack{}) do
        2
      end

      defoverridable Evercraft.Equipment

    end
  end

  def fighter(), do: Evercraft.Classes.Fighter
  def rogue(), do: Evercraft.Classes.Rogue

end
