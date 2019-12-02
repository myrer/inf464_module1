class Individu
    attr_accessor :chromosome, :score, :probabilite, :prob_cumulee
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


  #Le compte de chaque groupe commence à 0.
  groupe_compte = Hash.new
  ["41","42","43","44","45","46","47","48"].each{|groupe| groupe_compte[groupe] = 0}
  ["ELA1","EESL1","EESL3", "EESL5","EESL7","ESL3","ESL5","ESL7" ].each{|groupe| groupe_compte[groupe] = 0}

  profil_gr_anglais = { "41-ELA" => "ELA1", "41-EESL" => "EESL1",
                        "42-ELA" => "ELA1", "42-EESL" => "EESL1",
                        "43-ESL" => "ESL3", "43-EESL" => "EESL3",
                        "44-ESL" => "ESL3", "44-EESL" => "EESL3",
                        "45-ESL" => "ESL5", "45-EESL" => "EESL5",
                        "46-ESL" => "ESL5", "46-EESL" => "EESL5",
                        "47-ESL" => "ESL7", "47-EESL" => "EESL7",
                        "48-ESL" => "ESL7", "48-EESL" => "EESL7" }


  #Compter le nombre d'élèves par groupe
  chromosome.each_with_index do |groupe, index|
    groupe_compte[groupe] += 1

    profil = "#{groupe}-#{eleves[index][4]}"
    anglais = profil_gr_anglais[profil]
    #puts "#{profil} #{anglais}"
    groupe_compte[anglais] += 1
  end

  #groupe_compte.each {|g,c| print "#{g}:#{c}\t"}
  #puts
  erreurs = 0

  #Compter les erreurs dues aux dépassements dans les groupes de base
  groupe_max = Hash.new
  groupe_max["41"] = 33
  groupe_max["42"] = 36
  groupe_max["43"] = 33
  groupe_max["44"] = 36
  groupe_max["45"] = 33
  groupe_max["46"] = 36
  groupe_max["47"] = 33
  groupe_max["48"] = 33
  groupe_max["ELA1"] = 36
  groupe_max["EESL1"] = 36
  groupe_max["EESL3"] = 36
  groupe_max["EESL5"] = 36
  groupe_max["EESL7"] = 36
  groupe_max["ESL3"] = 31
  groupe_max["ESL5"] = 31
  groupe_max["ESL7"] = 31

  groupe_compte.each do |groupe, compte|
    if compte > groupe_max[groupe]
      erreurs += compte - groupe_max[groupe]
    end
    erreurs += (compte - 33).abs
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
    somme_prob += individu.probabilite
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
eleves = eleves.shuffle

#---Hyperparamètres
population = 800
nombre_generations = 1000
taux_mutation = 0.02
nombre_mutations = (taux_mutation * population).to_i
mutation_par_chromosome = 10
longueur_chromosome = eleves.size
pcent = 0.0

groupes = ["41", "42", "43", "44", "45", "46", "47", "48" ]
max_score = 1000

#---Générer les individus de la génération initiale
individus = Array.new
attribut_groupes = { "REG"    => ["41", "43", "45", "47", "48"],
                     "ENR"    => ["42", "44", "46"],
                     "ELA"    => ["41", "42"],
                     "EESL"   => ["41", "42", "43", "44", "45", "46", "47", "48"],
                     "ESL"    => ["43", "44", "45", "46", "47", "48"],
                     "EPS"    => ["41", "42", "43", "44", "45", "46", "47", "48"],
                     "MULTI"  => ["41", "42", "43", "44"],
                     "SOCCER" => ["41", "42", "43", "44"],
                     "VOLLEY" => ["41", "42", "43", "44"],
                     "CST4"   => ["41", "43", "48"],
                     "SN4"    => ["41", "42", "43", "44", "45", "46", "47", "48"]}

population.times do
  chromosome = Array.new
  longueur_chromosome.times do |index|
    eleve = eleves[index]
    groupes_permis = groupes
    for i in 3..6 do
      groupes_permis = groupes_permis & attribut_groupes[eleve[i]]
    end
    chromosome << groupes_permis.sample
  end

  s = score(chromosome, eleves)
  individu = Individu.new
  individu.chromosome = chromosome
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
      index = rand(longueur_chromosome)
      eleve = eleves[index]
      groupes_permis = groupes
      for i in 3..6 do
        groupes_permis = groupes_permis & attribut_groupes[eleve[i]]
      end
      if groupes_permis.empty?
        raise "pas de groupe"
      end
      nouveaux_individus.sample.chromosome[index] = groupes_permis.sample
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
eleves.sort{|a,b| a[9] <=> b[9] }.each{|e| puts e.join("\t")}

groupes.each do |gr|
  nombre = eleves.select{|el| el[9] == gr}.size
  puts "#{gr} #{nombre}"
end
puts "Anglais"
puts "ELA 1 : #{eleves.select{|el| el[9] == "41" or el[9] == "42" and el[4] == "ELA"}.size}"
puts "EESL 1: #{eleves.select{|el| el[9] == "41" or el[9] == "42" and el[4] == "EESL"}.size}"
puts "EESL 3: #{eleves.select{|el| el[9] == "43" or el[9] == "44" and el[4] == "EESL"}.size}"
puts "ESL 3 : #{eleves.select{|el| el[9] == "43" or el[9] == "44" and el[4] == "ESL"}.size}"
puts "EESL 3: #{eleves.select{|el| el[9] == "45" or el[9] == "46" and el[4] == "EESL"}.size}"
puts "ESL 5 : #{eleves.select{|el| el[9] == "45" or el[9] == "46" and el[4] == "ESL"}.size}"
puts "EESL 7: #{eleves.select{|el| el[9] == "47" or el[9] == "48" and el[4] == "EESL"}.size}"
puts "ESL 7 : #{eleves.select{|el| el[9] == "47" or el[9] == "48" and el[4] == "ESL"}.size}"

puts eleves.size
