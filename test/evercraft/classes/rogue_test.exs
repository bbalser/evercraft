defmodule Evercraft.Classes.RogueTest do
  use ExUnit.Case

  alias Evercraft.{ Attack, Character }

  import Evercraft.Class, only: [rogue: 0]

  describe "A rogue" do

    setup do
      [rogue: Character.new(name: "Rogue", class: rogue())]
    end

    test "does triple damage on a successfull critical hit", %{rogue: rogue} do

      defender = Character.new(name: "Defender")
      attack = Attack.new(rogue, defender, 20)

      hit_defender = Attack.apply_damage(attack)

      assert Character.hit_points(hit_defender) == Character.hit_points(defender) - 3

    end

    test "ignores opponents dexterity modifier during an attack", %{rogue: rogue} do

      defender = Character.new(name: "Defender", dexterity: 12)
      attack = Attack.new(rogue, defender, 10)

      assert Attack.hit?(attack) == true

    end

    test "does not ignore opponents dexterity modifier during an attack if it is negative", %{rogue: rogue} do

      defender = Character.new(name: "Defender", dexterity: 8)
      attack = Attack.new(rogue, defender, 9)

      assert Attack.hit?(attack) == true

    end

    test "adds dexterity modifier to attacks rather than strength" do

      rogue = Character.new(name: "Rogue", class: rogue(), dexterity: 12)
      defender = Character.new(name: "Defender")
      attack = Attack.new(rogue, defender, 9)

      assert Attack.hit?(attack) == true

    end

  end

end
