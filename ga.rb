class Individu
    attr_accessor :chromosome, :score, :probabilite
end

def chromosome_au_hasard(symbols, n)
  chromosome = Array.new
  n.times{ chromosome << symbols.sample }
  return chromosome
end

def afficher_chromosome_1d(c)
    puts c.join
end

def afficher_chromosome_2d(a, col, rang)
  for r in 0..rang-1
    puts a[r*col, col].join("")
  end
end

def score(c, ref)
  somme = 0
  c.each_with_index do |e,i|
    if c[i] == ref[i]
      somme = somme + 1
    end
  end
  return somme
end

#=====
#---Hyperparamètres
population = 1000
colonnes = 13
rangees = 7
longueur_chromosome = colonnes*rangees
symboles = [".", "+"]

ref = Array.new
str1d = "...*******....*.........*.*..**...**..**.....*.....*.*.........*...*...**..*.....*......*.."
str1d.each_char { |chr| ref << chr  }

#---Générer les individus de la génération initiale
individus = Array.new

population.times do
  c = chromosome_au_hasard(symboles, longueur_chromosome)
  s = score(c, ref)
  individu = Individu.new
  individu.chromosome =  c
  individu.score = s

  individus << individu
end

# Calculer la probabilite de reproduction : score / somme des scores
somme_scores = 0
individus.each{|individu| somme_scores = somme_scores + individu.score}

individus.each{|individu| individu.probabilite = individu.score.to_f/somme_scores.to_f}

#Afficher ref
afficher_chromosome_1d(ref)
afficher_chromosome_2d(ref,colonnes,rangees)
puts

individus.sort{|a,b| a.probabilite <=> b.probabilite}.each do |individu|
  #afficher_chromosome_1d(c)
  puts "#{individu.score} #{individu.probabilite}"
  #afficher_chromosome_2d(c,colonnes,rangees)
  #puts
end
