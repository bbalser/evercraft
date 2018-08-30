defmodule Evercraft.Race do

  defmacro __using__(_opts) do
    quote do
      use Evercraft.Equipment

      defoverridable Evercraft.Equipment
    end
  end

  def human(), do: Evercraft.Race.Human

end
