n = ARGV[0].to_i
somme = 0
for i in 1..n do
  entier_pair = 2*i-1
  somme = somme + entier_pair
  puts "#{entier_pair} : #{somme}"
end
