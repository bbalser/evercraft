defmodule Evercraft.Equipment do

  @callback attack_bonus(%Evercraft.Attack{}) :: integer
  @callback damage_bonus(%Evercraft.Attack{}) :: integer

  defmacro __using__(_opts) do
    quote do
      @behaviour Evercraft.Equipment

      def attack_bonus(%Evercraft.Attack{}) do
        0
      end

      def damage_bonus(%Evercraft.Attack{}) do
        0
      end

      defoverridable Evercraft.Equipment

    end
  end

end

defmodule Evercraft.Class do

  defmacro __using__(_opts) do
    quote do
      use Evercraft.Equipment

      def attack_bonus(%Evercraft.Attack{attacker: attacker}) do
        Evercraft.Character.strength(attacker) |> Evercraft.Ability.modifier()
      end

      def damage_bonus(%Evercraft.Attack{attacker: attacker}) do
        Evercraft.Character.strength(attacker) |> Evercraft.Ability.modifier()
      end

      defoverridable attack_bonus: 1,
                     damage_bonus: 1

    end
  end

end
