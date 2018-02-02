
defmodule Outcomes do
  def partitions(cards, subtotal) do
    Enum.reduce([0,1,2,3,4,5,6,7,8,9], 0, fn(i, acc) ->
      case elem(cards,i)>0 do
	:true ->
	  cond do
	    subtotal+i+1 > 21 -> acc
	    subtotal+i+1==21 -> acc+1
	    subtotal+i+1 < 21 ->
	      acc+1+partitions(put_elem(cards,i,elem(cards,i)-1),subtotal+i+1)
	  end
	:false -> acc
      end
    end)
  end
end

deck = Tuple.append(4 |> Tuple.duplicate(9), 16)

d =
  Enum.sum(
    for i <- 0..9 do
      new_deck = put_elem(deck, i, elem(deck, i)-1)
      p =
      Enum.sum(
	for j <- 0..9 do
	  Outcomes.partitions(put_elem(new_deck, j, elem(new_deck, j)-1), j+1)
	end)
      IO.puts "Dealer showing #{i} partitions = #{p}"
      p
    end
  )

IO.puts "Total partitions = #{d}"
