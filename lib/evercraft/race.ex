defmodule Evercraft.Race do

  defmacro __using__(_opts) do
    quote do
      use Evercraft.Equipment

      defoverridable Evercraft.Equipment
    end
  end

  def human(), do: Evercraft.Race.Human
  def orc(), do: Evercraft.Race.Orc
  def dwarf(), do: Evercraft.Race.Dwarf
  def elf(), do: Evercraft.Race.Elf

end
