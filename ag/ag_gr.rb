class Individu
    attr_accessor :chromosome, :score, :probabilite, :prob_cumulee
end

def chromosome_au_hasard(symboles, n)
  chromosome = Array.new
  n.times{ chromosome << symboles.sample }
  return chromosome
end

def afficher_chromosome(c)
    puts c.join
end

def score(c)
  max_par_groupe = 33
  surplus = 0
  tot2 = tot4 = tot6 = 0
  c.each do |e|
    if e == 2
      tot2 = tot2 + 1
    end
    if e == 4
      tot4 = tot4 + 1
    end
    if e == 2
      tot6 = tot6 + 1
    end
  end

  if tot2 > max_par_groupe
    surplus = surplus + tot2 - max_par_groupe
  end

  if tot4 > max_par_groupe
    surplus = surplus + tot4 - max_par_groupe
  end

  if tot6 > max_par_groupe
    surplus = surplus + tot6 - max_par_groupe
  end
  #puts "#{surplus} : #{tot2} #{tot4} #{tot6}"
  return 1000- surplus
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
population = 10
nombre_generations = 1000
taux_mutation = 0.02
nombre_mutations = (taux_mutation * population).to_i
mutation_par_chromosome = 5
longueur_chromosome = 99
pcent = 0.0

ref = Array.new
symboles = [2, 4, 6]
max_score = 1000

#---Générer les individus de la génération initiale
individus = Array.new

population.times do
  c = chromosome_au_hasard(symboles, longueur_chromosome)
  s = score(c)
  individu = Individu.new
  individu.chromosome =  c
  individu.score = s

  individus << individu
end

#Calculer la probabilite de reproduction : score / somme des scores
individus, somme_scores = calculer_probabilite_reproduction(individus)
best = individus.last

individus.each{|i| puts "#{i.chromosome.join(",")} #{i.score}"}
#exit

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
    nouvel_individu.score = score(chromosome_croise)

    nouveaux_individus << nouvel_individu
  end

  #Mutations
  nombre_mutations.times do
    mutation_par_chromosome.times do
      nouveaux_individus.sample.chromosome[rand(longueur_chromosome)] = symboles.sample
    end
  end

  nouveaux_individus, somme_scores = calculer_probabilite_reproduction(nouveaux_individus)

  #swap
  copie = individus
  individus = nouveaux_individus
  nouveaux_individus = copie

  best = individus.last
  max_score = 1000

  puts "Gen :  #{gen} Best : #{best.score} Avg : #{somme_scores/population}"
  sleep(1)
  afficher_chromosome(best.chromosome)

  if best.score == max_score
    puts "BINGO!"
    individus.each{|i| puts "#{i.chromosome.join(",")} #{i.score}"}
    break
  end
end
