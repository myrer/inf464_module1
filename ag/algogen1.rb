class Individu
    attr_accessor :chromosome, :score, :probabilite, :prob_cumulee
end

def lire_text_art(fname)
  ary = Array.new
  f = File.open(fname, "r")

  while ligne = f.gets
    ligne = ligne.chomp
    ligne.each_char { |chr| ary << chr  }
  end
  f.close

  return ary
end

def chromosome_au_hasard(symboles, n)
  chromosome = Array.new
  n.times{ chromosome << symboles.sample }
  return chromosome
end

def afficher_chromosome_1d(c)
    puts c.join
end

def afficher_chromosome_2d(a, col, rang)
  for r in 0..rang-1
    print "\t"*3
    puts a[r*col, col].join("")
  end
end

def score(c, ref)
  somme = 0
  ref.size.times do |i|
    if ref[i] == c[i]
      somme = somme + 1
    end
  end
  return somme
end

def calculer_probabilite_reproduction(individus)
  somme_scores = 0
  individus.each{|individu| somme_scores = somme_scores + individu.score}
  individus.each{|individu| individu.probabilite = individu.score.to_f/somme_scores.to_f}
  somme_prob = 0.0
  individus = individus.sort{|a,b| a.probabilite <=> b.probabilite}
  individus.each do |individu|
    somme_prob = somme_prob + individu.probabilite
    individu.prob_cumulee = somme_prob
  end
  return individus, somme_scores
end

def choisir_individu_au_hasard(individus)
  delta = 0.001
  while
    prob = rand
    tmp = individus.select{|individu| individu.prob_cumulee >= prob - delta and individu.prob_cumulee <= prob + delta}
    return tmp.first if !tmp.empty?
  end
end

def croiser_chromosomes(chromosome1, chromosome2)
  #Croiser les parents
  longueur_chromosome = chromosome1.size
  index1 = rand(longueur_chromosome-1)
  index2 = rand(longueur_chromosome-1)
  if index1 > index2
    tmp = index1
    index1 = index2
    index2 = tmp
  end
  #puts "#{index1}\t #{index2}"
  if index1 == 0
    index1 = 1
  end

  chromosome_croise = chromosome1[0..(index1-1)] + chromosome2[index1..index2] + chromosome1[(index2+1)..-1]
  if chromosome_croise.size != longueur_chromosome
    puts "="*100
    puts chromosome1.join
    puts chromosome2.join
    puts chromosome_croise.join
    puts "="*100
    raise "chromosome_croise illegal size"
  end
  return chromosome_croise
end

#=====

#---Hyperparamètres
population = 1500
nombre_generations = 800
taux_mutation = 0.02
nombre_mutations = (taux_mutation * population).to_i
mutation_par_chromosome = 5
colonnes = 13
rangees = 7
longueur_chromosome = colonnes*rangees
pcent = 0.0

ref = Array.new
#str1d  =  ".._\\||\\///.../.........\\..|..0...0...|.|....\\/....|..\\..\\___/../...\\......./.....|......|.."
ref = lire_text_art("text_art_1.txt")
symboles = ref.uniq
max_score = longueur_chromosome*symboles.size
#afficher_chromosome_1d(ref)
#afficher_chromosome_2d(ref, colonnes, rangees)

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

#Calculer la probabilite de reproduction : score / somme des scores
individus, somme_scores = calculer_probabilite_reproduction(individus)
best = individus.last

puts "Let's go!"
nouveaux_individus = Array.new
nombre_generations.times do |gen|
  nouveaux_individus.clear
  population.times do |i|

    parent1 = choisir_individu_au_hasard(individus)
    parent2 = choisir_individu_au_hasard(individus)
    chromosome_croise = croiser_chromosomes(parent1.chromosome, parent2.chromosome)

    nouvel_individu = Individu.new
    nouvel_individu.chromosome =  chromosome_croise
    nouvel_individu.score = score(chromosome_croise, ref)

    nouveaux_individus << nouvel_individu
  end
  nouveaux_individus, somme_scores = calculer_probabilite_reproduction(nouveaux_individus)

  #Mutations
  if pcent >= 97.0
    nombre_mutations_ajustees = nombre_mutations/2
  else
    nombre_mutations_ajustees = nombre_mutations
  end
  nombre_mutations.times do
    mutation_par_chromosome.times do
      nouveaux_individus.sample.chromosome[rand(longueur_chromosome)] = symboles.sample
    end
  end

  #swap
  copie = individus
  individus = nouveaux_individus
  nouveaux_individus = copie

  best = individus.last
  max_score = longueur_chromosome
  pcent = (100*best.score.to_f/max_score.to_f).round

  puts "Gen :  #{gen}: Best : #{pcent}% Moy : #{somme_scores/population}"
  afficher_chromosome_2d(best.chromosome,colonnes,rangees)

  if best.score == max_score
    puts "BINGO!"
    break
  end
end

puts "\nReference"
afficher_chromosome_2d(ref,colonnes,rangees)
