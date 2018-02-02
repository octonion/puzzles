
defmodule Outcomes do
  def partitions(cards, subtotal) do
    Enum.reduce([0,1,2,3,4,5,6,7,8,9], 0, fn(i, acc) ->
      case Enum.at(cards,i)>0 do
	:true ->
	  cond do
	    subtotal+i+1 > 21 -> acc
	    subtotal+i+1==21 -> acc+1
	    subtotal+i+1 < 21 ->
	      acc+1+partitions(
		Enum.slice(cards,0,i)++[Enum.at(cards,i)-1 | Enum.slice(cards,(i+1)..9)],subtotal+i+1)
	  end
	:false -> acc
      end
    end)
  end
end

deck = [4,4,4,4,4,4,4,4,4,16]

d =
  Enum.sum(
    for i <- 0..9 do
      new_deck = Enum.slice(deck,0,i)++[Enum.at(deck,i)-1 | Enum.slice(deck,(i+1)..9) ]
      p =
      Enum.reduce([0,1,2,3,4,5,6,7,8,9], 0, fn(j,acc) -> acc+
	Outcomes.partitions(
	  Enum.slice(new_deck,0,j)++[Enum.at(new_deck,j)-1 | Enum.slice(new_deck,(j+1)..9) ],
	  j+1)
      end)
      IO.puts "Dealer showing #{i} partitions = #{p}"
      p
    end
  )

IO.puts "Total partitions = #{d}"
