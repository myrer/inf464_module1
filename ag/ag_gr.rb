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

def score(chromosome, eleves)
  #---chromosome
  #chromosome est un objet Array
  #Exemple : ["44", "46", "44", "42", ..., "42"]
  # index       0     1     2     3         -1
  #L'index de chromosome correspond au numéro de l'éleve.
  #Chaque élément de chromosome est un objet String qui correspond au groupe de
  # l'élève.
  #Exemple : chromosome[2] correspond à l'élève ayant le numéro 2 et nous
  #          proposons le mettre dans le groupe 44.

  #---eleves
  #eleves est un objet Array dont chaque élément est un autre objet Array
  #qui contient les informations d'un élève en particulier.
  #L'index de eleves correspond au numéro de l'éleve.
  # Exemple :
  #     [
  #  0      ["0", "M", "11", "ENR", "ELA", "MULTI", "SN4", "CBO", "INF4"],
  #  1      ["1", "M", "11", "REG", "EESL", "EPS", "SN4", "GTR", "REGS4"],
  #  2      ["2", "F", "9", "REG", "ESL", "EPS", "SN4", "DAN", "REGS4"],
  #             ...
  # -1      ["265", "M", "9", "ENR", "EESL", "SOCCER", "SN4", "DRA", "PSY4"]
  #     ]
  #           0    1    2     3      4        5        6      7       8
  #
  #Pour obtenir le niveau d'anglais de l'élève 2 : eleves[2][4]
  #Pour obtenir le cours d'art du dernier élève : eleves[-1][7]

  groupe_compte = Hash.new
  #Le compte de chaque groupe commence à 0.
  #["41","42","43","44","45","46","47","48"].each{|groupe| groupe_compte[groupe] = 0}
  groupe_compte["41"] = 0
  groupe_compte["42"] = 0
  groupe_compte["43"] = 0
  groupe_compte["44"] = 0
  groupe_compte["45"] = 0
  groupe_compte["46"] = 0
  groupe_compte["47"] = 0
  groupe_compte["48"] = 0

  chromosome.each do |groupe|
    groupe_compte[groupe] += 1 #idem à groupe_compte[groupe] = groupe_compte[groupe] + 1
  end

  groupe_max = Hash.new
  groupe_max["41"] = 33
  groupe_max["42"] = 36
  groupe_max["43"] = 33
  groupe_max["44"] = 36
  groupe_max["45"] = 33
  groupe_max["46"] = 36
  groupe_max["47"] = 33
  groupe_max["48"] = 33


  erreurs = 0

  groupe_compte.each do |groupe, compte|
    if compte > groupe_max[groupe]
      erreurs += compte - groupe_max[groupe]
    end
  end

  return 1000 - erreurs
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
#Lire les données des élèves et les mettre dans un objet Array
nom_fichier = "t4.csv"
eleves = Array.new
f = File.open(nom_fichier, "r")
while ligne = f.gets
	ligne = ligne.chomp
	donnees = ligne.split(";")
	eleves << donnees
end
f.close

#---Hyperparamètres
population = 1000
nombre_generations = 1000
taux_mutation = 0.02
nombre_mutations = (taux_mutation * population).to_i
mutation_par_chromosome = 5
longueur_chromosome = eleves.size
pcent = 0.0

symboles = ["41", "42", "43", "44", "45", "46", "47", "48" ]
max_score = 1000

#---Générer les individus de la génération initiale
individus = Array.new

population.times do
  c = chromosome_au_hasard(symboles, longueur_chromosome)
  s = score(c, eleves)
  individu = Individu.new
  individu.chromosome =  c
  individu.score = s

  individus << individu
end

#Calculer la probabilite de reproduction : score / somme des scores
individus, somme_scores = calculer_probabilite_reproduction(individus)
best = individus.last

#individus.each{|i| puts "#{i.chromosome.join(",")} #{i.score}"}
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
    nouvel_individu.score = score(chromosome_croise, eleves)

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
  #afficher_chromosome(best.chromosome)

  if best.score == max_score
    puts "BINGO!"

    break
  end
end

best.chromosome.each_with_index {|groupe, index| eleves[index] << groupe }
eleves.sort{|a,b| a[9] <=> b[9] }.each{|e| puts e.join(",")}

symboles.each do |gr|
  nombre = eleves.select{|el| el[9] == gr}.size
  puts "#{gr} #{nombre}"
end
puts eleves.size
