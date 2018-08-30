defmodule Evercraft.Class.PaladinTest do
  use ExUnit.Case
  import Checkov
  import Evercraft.Class, only: [paladin: 0]
  alias Evercraft.{ Alignment, Attack, Character}

  describe "A Paladin" do

    data_test "has #{hit_points} hit points at level #{level}" do

      exp = (level * 1000) - 1000
      paladin = Character.new(name: "Paladin", class: paladin(), experience: exp)

      assert Character.hit_points(paladin) == hit_points

      where level:      [1, 2, 3, 4, 5],
            hit_points: [8,16,24,32,40]

    end

    test "has +2 to attack rolls when fighting an evil character" do
      paladin = Character.new(name: "Paladin", class: paladin())
      evil_defender = Character.new(name: "Evil", alignment: Alignment.evil)
      attack = Attack.new(paladin, evil_defender, 8)

      assert Attack.hit?(attack) == true
    end

    test "has +0 to attack rolls when fighting an non evil character" do
      paladin = Character.new(name: "Paladin", class: paladin())
      defender = Character.new(name: "Neutral")
      attack = Attack.new(paladin, defender, 8)

      assert Attack.hit?(attack) == false
    end

    test "does triple damage when critically hitting an evil character" do
      paladin = Character.new(name: "Paladin", class: paladin())
      evil_defender = Character.new(name: "Evil", alignment: Alignment.evil)
      attack = Attack.new(paladin, evil_defender, 20)

      hurt_defender = Attack.apply_damage(attack)

      assert Character.hit_points(hurt_defender) == Character.hit_points(evil_defender) - 3
    end


  end



end
