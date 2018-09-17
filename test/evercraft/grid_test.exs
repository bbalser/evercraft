defmodule Evercraft.GridTest do
  use ExUnit.Case
  import Checkov
  alias Evercraft.Grid


  test "can create map of any size" do
    grid = Grid.new(5, 7)

    assert Grid.range(grid) == {1..5, 1..7}
  end

  test "terms can be put into grid" do
    grid = Grid.new(10, 10)
    {:ok, grid} = Grid.put(grid, {2,2}, :success)

    assert Grid.get(grid, {2,2}) == :success
  end

  test "terms cannot be put outside of grid boundries along x axis" do
    grid = Grid.new(10, 10)
    {:error, error} = Grid.put(grid, {12, 8}, :term)

    assert error == "Cannot place item at {12, 8}, grid boundries are (1..10, 1..10)"
  end

  test "terms cannot be put outside of grid boundries along y axis" do
    grid = Grid.new(11, 8)
    {:error, error} = Grid.put(grid, {8, 12}, :term)

    assert error == "Cannot place item at {8, 12}, grid boundries are (1..11, 1..8)"
  end

  test "put! will raise exception when grid boundries are not respected" do
    grid = Grid.new(11, 8)

    assert_raise Grid.OutOfBoundsException, "Cannot place item at {8, 12}, grid boundries are (1..11, 1..8)", fn ->
      Grid.put!(grid, {8, 12}, :term)
    end
  end

  data_test "can set #{inspect term} at coordinate #{x}, #{y}" do
    grid = Grid.new(10, 10)
    |> Grid.put!({x, y}, term)

    assert Grid.get(grid, {x, y}) == term

    where term: ["Hi", :atom],
          x:    [   1,     4],
          y:    [   1,     7]
  end

  test "can find term in map by function" do
    grid = Grid.new(10, 10)
      |> Grid.put!({3, 7}, :one)
      |> Grid.put!({7, 3}, :two)

    assert Grid.find(grid, fn x -> x == :one end) == {3, 7}
  end

  test "can find term in map by value" do
    grid = Grid.new(10, 10)
      |> Grid.put!({3, 7}, :one)
      |> Grid.put!({7, 3}, :two)

    assert Grid.find(grid, :two) == {7, 3}
  end

  data_test "move! will move entry #{direction}" do
    grid = Grid.new(10, 10)
      |> Grid.put!({5,5}, :term)
      |> Grid.move!(:term, direction)

    assert Grid.find(grid, :term) == coordinate

    where direction:  [:right,  :left,    :up,  :down],
          coordinate: [{6, 5}, {4, 5}, {5, 4}, {5, 6}]

  end

  test "move! will throw an exception when attempting to entry to an occupied coordinate" do
    grid = Grid.new(10, 10)
      |> Grid.put!({1,1}, :tree)
      |> Grid.put!({2,1}, :person)

    assert_raise Grid.EntryExistsAtTargetCoordinate, "Cannot move entry at {2, 1} left, coordinate already taken", fn ->
      Grid.move!(grid, :person, :left)
    end
  end


end
