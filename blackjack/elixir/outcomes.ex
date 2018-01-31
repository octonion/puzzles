
defmodule Outcomes do
  def partitions(cards, subtotal) do
    Enum.sum(
    for i <- 0..9, elem(cards,i)>0 do
      cond do
	subtotal+i+1 > 21 -> 0
	subtotal+i+1==21 -> 1
	subtotal+i+1 < 21 ->
	  1+partitions(put_elem(cards, i, elem(cards,i)-1), subtotal+i+1)
      end
    end
    )
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
	  end
	)
      IO.puts "Dealer showing #{i} partitions = #{p}"
      p
    end
  )

IO.puts "Total partitions = #{d}"
