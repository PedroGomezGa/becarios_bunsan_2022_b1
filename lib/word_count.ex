defmodule WordCount do
  def count(words, map) do
    Enum.map(words, fn x->
      Map.put(map, x, 1)
    end)
  end

  def each([_h]), do: Map.new()
  def each([h|t]) do
    Map.merge(h, each(t), fn _k, v1, v2 ->
      v1 + v2
    end)
  end

  def read(path) do
    {:ok, string} = File.read(path)
    WordCount.each(WordCount.count(WordCount.tolist(string), Map.new())) 
  end

  def tolist(string) do
    string
    |> String.normalize(:nfd)
    |> String.replace(~r/,(?=[^\s])/u,", ")
    |> String.replace(~r/\.(?=[^\s])/u,". ")
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.downcase()
    |> String.split(~r/\s+/)
  end
end