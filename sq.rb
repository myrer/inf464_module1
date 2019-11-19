require_relative "textimage.rb"
require_relative "individu.rb"

def lire(fname)
  ary = Array.new
  f = File.open(fname, "r")
  while ligne = f.gets
    ligne = ligne.chomp
    if ligne.empty?
      puts "empty"
      ligne = " "*10
    end
    if ligne.size > 10
      ligne = ligne[0,10]
    else
      ligne = ligne.ljust(10, ".")
    end
    ary.push(ligne)
  end
  f.close
  return ary
end

def random_textimage(symbols, rows = 10, cols=10)
  ary = Array.new
  for row in 0..rows-1
    str = String.new
    cols.times do
      str << symbols.sample
    end
    ary.push(str)
  end
  return ary
end
def fitness(a,b)
end

#=====
system("clear")

sq = Textimage.new("sq", lire("square.txt"))
symboles = sq.symboles
puts "#{symboles.size}\: #{symboles.inspect}"

puts sq.nom
sq.afficher

#---Hyperparamètres
n = 1000

#---Population initiale
population = Array.new

for i in 0..n-1
  ti = Textimage.new("I#{i}", random_textimage([".", "*"]))
  population.push( Individu.new(ti.pixels.flatten, ti.comparer(sq), ti) )
end

scores = population.collect do |individu|
  individu.fitness
end
scores = scores.uniq.sort

somme_scores = 0
scores.each do |score|
  somme_scores = somme_scores + score
end

sum = 0
scores.each do |score|
  pcent = score.to_f/somme_scores*100.0
  puts "#{score} / #{somme_scores}\ #{pcent}"
  sum = sum + pcent
end

puts sum

#population.sort{|a,b| a.fitness <=> b.fitness}.each do |individu|
#  puts individu
#end
