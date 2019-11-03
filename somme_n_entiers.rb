n = ARGV[0].to_i
somme = 0
for i in 1..n do
  somme = somme + i
  puts "#{i} : #{somme}"
end
