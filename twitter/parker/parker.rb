
words = File.open('five.txt').select { |word| word.chars.uniq == word.chars }

for word in words
  print(word.strip())
  for letter in 'a'..'z'
    if word.include?(letter)
      print(" 1")
    else
      print(" 0")
    end
  end
  print("\n")
end
