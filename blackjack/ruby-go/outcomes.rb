#!/usr/bin/env ruby

require 'ffi'

module Go
  extend FFI::Library
  ffi_lib "./libpartitions.so"

  class GoSlice < FFI::Struct
    layout :data,  :pointer,
           :len,   :long_long,
           :cap,   :long_long
  end

  attach_function :partitions, [ GoSlice.by_value, :long_long ], :long_long
end

deck = ([4]*9)
deck << 16

d = 0

for i in 0..9
  # Dealer showing
  deck[i] = deck[i]-1
  p = 0
  for j in 0..9
    deck[j] = deck[j]-1
    pointer = FFI::MemoryPointer.new :long_long, deck.size
    pointer.put_array_of_long_long 0, deck
    cards = Go::GoSlice.new
    cards[:data] = pointer
    cards[:len] = deck.size
    cards[:cap] = deck.size
    n = Go.partitions(cards, j+1)
    deck[j] = deck[j]+1
    p += n
  end
  print("Dealer showing #{i} partitions = #{p}\n")
  d += p
  deck[i] = deck[i]+1
end

print("Total partitions = #{d}\n")
