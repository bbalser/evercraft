defmodule Evercraft.CharacterTests do
  use ExUnit.Case
  import Checkov

  alias Evercraft.{ Alignment, Character }

  describe "A default character" do

    setup [:new_character]

    test "has a name", %{character: character} do
      assert Character.name(character) == "Default"
    end

    test "has a default alignment of neutral", %{character: character} do
      assert Character.alignment(character) == Alignment.neutral
    end

    test "has a default armor class of 10", %{character: character} do
      assert Character.armor_class(character) == 10
    end

    test "has 5 hit points by default", %{character: character} do
      assert Character.hit_points(character) == 5
    end

  end

  describe "a good character" do

    setup [:new_character, :turn_good]

    test "has a good alignment", %{character: character} do
      assert Character.alignment(character) == Alignment.good
    end

  end

  describe "an evil character" do

    setup [:new_character, :turn_evil]

    test "has an evil alignment", %{character: character} do
      assert Character.alignment(character) == Alignment.evil
    end

  end

  data_test "a character with #{hit_points} hit_points is #{if result, do: "alive", else: "dead"}" do
    character = Character.new(name: "Char", hit_points: hit_points)

    assert Character.alive?(character) == result

    where hit_points: [0,     1],
          result:     [false, true]
  end

  data_test "a hearty character of level #{level} includes constitution modifier in max_hit_points" do

    character = Character.new(name: "Charlie", constitution: 12, experience: (level-1)*1000)
    assert Character.max_hit_points(character) == max_hit_points

    where level:          [1,2 ,3 ,4 ,5],
          max_hit_points: [6,12,18,24,30]

  end

  describe "a sickly character" do

    setup do
      [character: Character.new(name: "Charlie", constitution: 1)]
    end

    test "has at least 1 hit_point", %{character: character} do
      assert Character.max_hit_points(character) == 1
      assert Character.hit_points(character) == 1
    end

  end

  data_test "a character with exp in range #{inspect exp_range} is level #{level}" do

    Enum.each(exp_range, fn exp ->
      character = Character.new(name: "George", experience: exp)
      assert Character.level(character) == level
    end)

    where exp_range: [0..999, 1000..1999, 2000..2999, 3000..3999],
          level:     [     1,          2,          3,          4]

  end

  data_test "a character of level #{level} has #{max_hit_points} max_hit_points" do

    character = Character.new(name: "Charlie", experience: (level-1) * 1000)
    assert Character.max_hit_points(character) == max_hit_points

    where level:          [1, 2,  3,  4 ],
          max_hit_points: [5, 10, 15, 20]

  end

  defp new_character(_context) do
    [character: Character.new(name: "Default")]
  end

  defp turn_good(%{character: character}) do
    [character: Character.copy(character, alignment: Alignment.good)]
  end

  defp turn_evil(%{character: character}) do
    [character: Character.copy(character, alignment: Alignment.evil)]
  end

end
