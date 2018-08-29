defmodule Evercraft.Classes.MonkTest do
  use ExUnit.Case
  import Checkov
  import Evercraft.Class, only: [monk: 0]

  alias Evercraft.{ Attack, Character }

  describe "A Monk" do

    data_test "has #{hit_points} at level #{level}" do

      exp = (level * 1000) - 1000
      monk = Character.new(name: "Monk", class: monk(), experience: exp)

      assert Character.max_hit_points(monk) == hit_points

      where level:      [1,    2,    3],
            hit_points: [6,   12,   18]
    end

    test "does 3 points of damage on a successful attack" do
      monk = Character.new(name: "Monk", class: monk())
      defender = Character.new(name: "Defender")
      attack = Attack.new(monk, defender, 10)

      damaged_defender = Attack.apply_damage(attack)

      assert Character.hit_points(damaged_defender) == Character.hit_points(defender) - 3
    end

    test "adds wisdom modifier and dexterity modifier to armor class" do

      monk = Character.new(name: "Monk", class: monk(), wisdom: 12, dexterity: 12)
      attacker = Character.new(name: "Attacker")
      attack = Attack.new(attacker, monk, 11)

      assert Attack.hit?(attack) == false

    end

    data_test "adds 1 to attack bonus every 2nd & 3rd level - level #{level}" do

      exp = (level * 1000) - 1000
      monk = Character.new(name: "Monk", class: monk(), experience: exp)
      defender = Character.new(name: "Defender")
      attack = Attack.new(monk, defender, roll)

      assert Attack.hit?(attack) == true

      where roll:  [10, 9, 8, 8, 7, 6, 6, 5, 4],
            level: [ 1, 2, 3, 4, 5, 6, 7, 8, 9]

    end

  end

end
