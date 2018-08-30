defmodule Evercraft.Class.FighterTest do
  use ExUnit.Case
  import Checkov
  alias Evercraft.{ Attack, Character }
  import Evercraft.Class, only: [fighter: 0]

  data_test "a fighter adds to 1 attack for every level - #{exp}" do

    fighter = Character.new(name: "Fighter", class: fighter(), experience: exp)
    attack = Attack.new(fighter, Character.new(name: "Defender"), roll)

    assert Attack.hit?(attack) == true

    where exp:  [0, 1000, 2000, 3000, 4000, 5000],
          roll: [10,   9,    8,    7,    6,    5]

  end

  data_test "a fighter of level #{level} has #{max_hit_points} max_hit_points" do

    character = Character.new(name: "Fighter", class: fighter(), experience: (level-1) * 1000)
    assert Character.max_hit_points(character) == max_hit_points

    where level:          [1,   2,  3,  4],
          max_hit_points: [10, 20, 30, 40]

  end

end
