defmodule Evercraft.Grid do
  @type direction :: :left | :right | :up | :down
  @type coordinate :: {integer, integer}
  @type t :: %__MODULE__{}

  defstruct range: nil,
            coordinates: %{}

  defmodule OutOfBoundsException do
    defexception [:message]
  end

  defmodule EntryExistsAtTargetCoordinate do
    defexception [:message]
  end

  @spec new(integer, integer) :: t
  def new(x_size, y_size) do
    %__MODULE__{range: {1..x_size, 1..y_size}}
  end

  @spec range(t) :: {Range.t(), Range.t()}
  def range(%__MODULE__{range: range}), do: range

  @spec put(t, coordinate, term) :: {:ok, t} | {:error, String.t()}
  def put(
        %__MODULE__{range: {x_axis, y_axis}, coordinates: coordinates} = grid,
        {x, y} = coordinate,
        term
      ) do
    cond do
      x not in x_axis or y not in y_axis ->
        {:error, "Cannot place item at #{inspect(coordinate)}, grid boundries are (#{inspect(x_axis)}, #{inspect(y_axis)})"}

      true ->
        {:ok, %{grid | coordinates: Map.put(coordinates, coordinate, term)}}
    end
  end

  @spec put!(t, coordinate, term) :: t | no_return
  def put!(%__MODULE__{} = grid, coordinate, term) do
    case put(grid, coordinate, term) do
      {:ok, grid} -> grid
      {:error, reason} -> raise OutOfBoundsException, message: reason
    end
  end

  @spec get(t, coordinate) :: term
  def get(%__MODULE__{coordinates: coordinates}, coordinate) do
    Map.get(coordinates, coordinate)
  end

  @spec find(t, function | term) :: coordinate
  def find(%__MODULE__{coordinates: coordinates}, function) when is_function(function) do
    Enum.find(coordinates, fn {_key, value} -> function.(value) end)
    |> elem(0)
  end

  def find(%__MODULE__{} = grid, term) do
    find(grid, fn entry -> entry == term end)
  end

  @spec move(t, term, direction) :: {:ok, t} | {:error, String.t}
  def move(%__MODULE__{coordinates: coordinates} = grid, term, direction) do
    coordinate = find(grid, fn entry -> entry == term end)
    transform = directional_transform(direction)

    target_coordinate = transform.(coordinate)

    case Map.has_key?(coordinates, target_coordinate) do
      true ->
        {:error, "Cannot move entry at #{inspect(coordinate)} #{direction}, coordinate already taken"}

      false ->
        {:ok, %{grid | coordinates: move_term(coordinates, coordinate, transform.(coordinate))}}
    end
  end

  @spec move!(t, term, direction) :: t | no_return
  def move!(%__MODULE__{} = grid, term, direction) do
    case move(grid, term, direction) do
      {:ok, grid} -> grid
      {:error, reason} -> raise EntryExistsAtTargetCoordinate, message: reason
    end
  end

  defp directional_transform(:right), do: fn {x, y} -> {x + 1, y} end
  defp directional_transform(:left), do: fn {x, y} -> {x - 1, y} end
  defp directional_transform(:up), do: fn {x, y} -> {x, y - 1} end
  defp directional_transform(:down), do: fn {x, y} -> {x, y + 1} end

  defp move_term(map, old_key, new_key) do
    Map.delete(map, old_key)
    |> Map.put(new_key, Map.get(map, old_key))
  end
end
