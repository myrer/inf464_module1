  class Individu
    attr_accessor :chromosome, :score, :probabilite, :prob_cumulee
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

def score(c, ref, symboles)
  symboles.delete_if{|x| x == " "}
  somme = 0
  points = symboles.size
  ref.each_with_index do |e,i|
    if ref[i] == c[i]
      somme = somme + points
    else
      if ref[i] != " " and symboles.include?(c[i])
        somme = somme + 1
      end
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
  return individus
end

def choisir_individu_au_hasard(individus)
  rv = Array.new
  done = false
  while !done
    prob = rand
    pp, pg = individus.partition{|individu| individu.prob_cumulee <= prob}
    rv = pp.last
    if !rv.nil?
      done = true
    end
  end
  return rv
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
population = 1000
nombre_generations = 800
taux_mutation = 0.02
nombre_mutations = (taux_mutation * population).to_i
mutation_par_chromosome = 5
colonnes = 13
rangees = 7
longueur_chromosome = colonnes*rangees

ref = Array.new
#str1d  = "   +++++++    +         + +  ++   ++  ++     +     + +         +   +   ++  +     +      +  "
str1d  =  "...\\||\\///.../.........\\..|..0...0...|.|....\\/....|..\\..\\___/../...\\......./.....|......|.."
str1d = str1d.gsub(".", " ")
str1d.each_char { |chr| ref << chr  }
symboles = ref.uniq
max_score = longueur_chromosome*symboles.size
#puts "Référence"
#afficher_chromosome_2d(ref,colonnes,rangees)
#puts
#---Générer les individus de la génération initiale
individus = Array.new

population.times do
  c = chromosome_au_hasard(symboles, longueur_chromosome)
  s = score(c, ref, symboles[1..-1])
  individu = Individu.new
  individu.chromosome =  c
  individu.score = s

  individus << individu
end

#Calculer la probabilite de reproduction : score / somme des scores
individus = calculer_probabilite_reproduction(individus)
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
    nouvel_individu.score = score(chromosome_croise, ref, symboles[1..-1])

    nouveaux_individus << nouvel_individu
  end
  nouveaux_individus = calculer_probabilite_reproduction(nouveaux_individus)

  #Mutations
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
  pcent = (100*best.score.to_f/max_score.to_f).round
  puts "Gen :  #{gen}: Score : #{pcent}%"
  afficher_chromosome_2d(best.chromosome,colonnes,rangees)
  if best.score == max_score
    puts "BINGO!"
    exit(0)
  end
end

puts "Reference"
afficher_chromosome_2d(ref,colonnes,rangees)
