defmodule AlphabetCipher.Coder do

  def encode(keyword, message) do
    alphabet = ["a","b","c","d","e","f","g","h","i","j","k",
    "l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    columns = 
    String.split(
        String.duplicate(
          keyword,
          div(length(alphabet), String.length(keyword))+2),
          "",trim: true)
   Enum.map(Enum.zip(columns, (String.split(message,"", trim: true))), fn {a,b} ->
    Enum.at(alphabet, 
    Enum.find_index(alphabet, fn x -> x == a end)-length(alphabet)+Enum.find_index(alphabet, fn x -> x == b end))
    end)
   |> Enum.join()
  end

  def decode(keyword, message) do
    alphabet = ["a","b","c","d","e","f","g","h","i","j","k",
    "l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    columns = 
    String.split(
        String.duplicate(
          keyword,
          div(length(alphabet), String.length(keyword))+2),
          "",trim: true)
   Enum.map(Enum.zip(columns, (String.split(message,"", trim: true))), fn {a,b} ->
    Enum.at(alphabet, 
    Enum.find_index(alphabet, fn x -> x == b end)-Enum.find_index(alphabet, fn x -> x == a end))
    end)
   |> Enum.join()
  end

  def decipher(cipher, message) do
    alphabet = ["a","b","c","d","e","f","g","h","i","j","k",
    "l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
  prashe = Enum.map(Enum.zip(
   (String.split(cipher,"", trim: true)), 
   (String.split(message,"", trim: true))), fn {a,b} ->
    Enum.at(alphabet, 
    Enum.find_index(alphabet, fn x -> 
    x == a end)-
    Enum.find_index(alphabet, fn x -> 
    x == b end))
    end)

  Enum.reduce_while(prashe,"", fn x, acc -> 
    if acc != List.to_string(Enum.slice(prashe, String.length(acc)..(String.length(acc)*2-1))), 
    do: {:cont, acc = acc <> x}, 
    else: {:halt, acc} end)
   end
end
