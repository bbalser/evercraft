defmodule Evercraft.AttackTest do
  use ExUnit.Case
  import Checkov

  alias Evercraft.{Attack, Character}

  setup [:attacker, :defender]

  data_test "is_hit is #{result} when roll is #{roll} with default armor class", %{attacker: attacker, defender: defender} do
    attack = Attack.new(attacker, defender, roll)

    assert Attack.hit?(attack) == result

    where roll:   [10  , 11  , 9],
          result: [true, true, false]

  end

  data_test "a attack with a roll of #{roll} causes #{damage} hit point of damage to defender", %{attacker: attacker, defender: defender} do
    attack = Attack.new(attacker, defender, roll)
    post_defender = Attack.apply_damage(attack)
    assert Character.hit_points(post_defender) == Character.hit_points(defender) - damage

    where roll:   [10, 19, 20],
          damage: [1 , 1,  2]

  end

  data_test "1 is added to attack roll for every even level - #{exp}" do

    attacker = Character.new(name: "Attacker", experience: exp)
    defender = Character.new(name: "Defender")
    attack = Attack.new(attacker, defender, roll)

    assert Attack.hit?(attack) == true

    where exp:  [0, 1000, 2000, 3000, 4000, 5000],
          roll: [10,   9,    9,    8,    8,    7]
  end

  describe "A strong attacker" do

    setup do
      attacker = Character.new(name: "Attacker", strength: 12)
      defender = Character.new(name: "Defender")
      [
        attack: Attack.new(attacker, defender, 9),
        critical_attack: Attack.new(attacker, defender, 20),
      ]
    end

    test "adds his strength modifier to attack rolls", %{attack: attack} do
      assert Attack.hit?(attack) == true
    end

    test "adds his strength modifier to damage dealt", %{attack: %Attack{defender: defender} = attack} do
      original_hit_points = Character.hit_points(defender)
      new_hit_points = Attack.apply_damage(attack) |> Character.hit_points()

      assert new_hit_points == original_hit_points - 2
    end

    test "adds double his strength modifier to damage dealt on critical hits", %{critical_attack: %Attack{defender: defender} = attack} do
      original_hit_points = Character.hit_points(defender)
      new_hit_points = Attack.apply_damage(attack) |> Character.hit_points()

      assert new_hit_points == original_hit_points - 4
    end

  end

  describe "A weak attacker" do

    setup do
      attacker = Character.new(name: "Attacker", strength: 1)
      defender = Character.new(name: "Defender")
      [
        critical_attack: Attack.new(attacker, defender, 20)
      ]
    end

    test "does a minimum of 1 damage on successful hits", %{critical_attack: %Attack{defender: defender} = attack} do
      original_hit_points = Character.hit_points(defender)
      new_hit_points = Attack.apply_damage(attack) |> Character.hit_points()

      assert new_hit_points == original_hit_points - 1
    end

  end

  describe "A dextrous defender" do

    setup do
      [
        attack: Attack.new(Character.new(name: "Attacker"), Character.new(name: "Defender", dexterity: 12), 10)
      ]
    end

    test "adds dexterity modifier to armor class", %{attack: attack} do
      assert Attack.hit?(attack) == false
    end

  end

  defp attacker(_context), do: [attacker: Character.new(name: "Attacker")]
  defp defender(_context), do: [defender: Character.new(name: "Defender")]

end
