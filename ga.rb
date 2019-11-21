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
def score(a,b)
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
  score = ti.comparer(sq)
  population.push( Individu.new(ti.pixels.flatten, score, ti) )
end

#---Calculer score
total_score = 0
population.each do |individu|
  total_score = total_score + individu.score
end

#----Calculer probabilité et cumulatif
sum = 0.0
population.sort{|a,b| a.score <=> b.score}.each_with_index do |individu, i|
  tmp = n * individu.score.to_f / total_score.to_f
  sum = sum + tmp
  individu.cumul= sum
end

population.sort{|a,b| a.score <=> b.score}.each_with_index do |individu, i|
  puts "#{i}\t #{individu.score} #{individu.cumul}"
end

#---Nouvelles générations

10.times do
  #---Choisir deux individus au hasard
  rnd = rand(n)
  ind1 = population.select{|x| x.cumul > rnd.to_f}.sort{|a,b| a.score <=> b.score}.first
  rnd = rand(n)
  ind2 = population.select{|x| x.cumul > rnd.to_f}.sort{|a,b| a.score <=> b.score}.first

  #Choisir deux points de césure
  cesure1 = rand(100)
  cesure2 = rand(100)
  chromo1 = ind1.chromosome
  chromo2 = ind2.chromosome

  #Effectuer le croisement en 2 points
  enfant1 = chromo1[0..(cesure1-1)] + chromo2[cesure1..cesure2] + chromo1[(cesure2+1)..-1]
  enfant2 = chromo2[0..(cesure1-1)] + chromo1[cesure1..cesure2] + chromo2[(cesure2+1)..-1]

end
