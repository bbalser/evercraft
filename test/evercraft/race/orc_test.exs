defmodule Evercraft.Race.OrcTest do
  use ExUnit.Case
  alias Evercraft.Character
  import Evercraft.Race, only: [orc: 0]

  describe "An Orc" do

    setup do
      [orc: Character.new(name: "Orc", race: orc())]
    end

    test "gets +4 to strength", %{orc: orc} do
      assert Character.strength(orc) == 14
    end

    test "gets a -2 to intelligence", %{orc: orc} do
      assert Character.intelligence(orc) == 8
    end

    test "gets a -2 to wisdom", %{orc: orc} do
      assert Character.wisdom(orc) == 8
    end

    test "gets a -2 to charisma", %{orc: orc} do
      assert Character.charisma(orc) == 8
    end

    test "gets a +2 to armor class", %{orc: orc} do
      assert Character.armor_class(orc) == 12
    end

  end

end
