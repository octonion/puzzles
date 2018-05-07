use "collections"

actor Main
  let _env: Env
    new create(env: Env) =>
      _env = env

  var deck = Array[U8](10)
  deck = [as U8: 4;4;4;4;4;4;4;4;4;16]
  var d: USize = 0

  for i in Range(0, 10) do
    // Dealer showing
    try
      deck(i)? = deck(i)?-1
    end
    var p: USize = 0
    
    for j in Range(0, 10) do
      try
	deck(j)? = deck(j)?-1
      end
      p = p+partitions(deck, j+1)
      try
        deck(j)? = deck(j)?+1
      end
    end

    env.out.print("Dealer showing "+i.string()+" partitions = "+p.string())
    d = d+p
    try
      deck(i)? = deck(i)?+1
    end
  end

  env.out.print("Total partitions = "+d.string())

  fun ref partitions(cards: Array[U8], subtotal: USize): USize =>
		
    var m: USize = 0
    // Hit
    for i in Range(0, 10) do
      if ((try cards(i)?>0 else false end)) then
        var total: USize = subtotal+i+1
        if total < 21 then
          // Stand
          m = m+1
          // Hit again
	  try
	    cards(i)? = cards(i)?-1
	  end
          m = m+partitions(cards, total)
	  try
  	    cards(i)? = cards(i)?+1
	  end
        elseif total == 21 then
          // Stand; hit again is an automatic bust
          m = m+1
        end
      end
    end        
    m
