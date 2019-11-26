# La variable villes est un objet Array qui contient 10 éléments qui sont tous
# des objets String.
villes =[ "Dallas;USA;22", "Rome;Italie;21", "La Prairie;Canada;2",
          "New York;USA;10", "Boston;USA;8",
          "Calgary;Canada;-3","Miami;USA;28","Hong Kong;Chine;24",
          "Toronto;Canada;5", "Vancouver;Canada;14"]


puts "\nAfficher toutes les villes\n"
# La méthode .each permet d'agir sur CHAQUE élément d'un objet Array.
# La variable el prendra la valeur de CHAQUE objet String contenu dans villes.
# Notez que la variable el est encadré par des lignes verticales | |.
# La variable el changera de valeur à chaque tour de boucle.
# Toutes les commandes encadrés par do et end seront exécutées pour chaque
# élément de l'objet Array villes.
# La variable el existe seulement dans le bloc de code fourni.
villes.each do |el|   # La variable el existe ici.
	puts el             # La variable el existe ici aussi.
end                   # La variable el n'exsite plus à partir de cette ligne.

puts "\nAfficher les villes canadiennes\n"
# La méthode .select SÉLECTIONNE des éléments d'un objet Array selon les
# directives programmées dans le bloc de code fourni : {|el| el.include?("Canada")}
# La variable el prendra la valeur de CHAQUE objet String contenu dans villes.
# Si la valeur de la variable el inclut un objet String "Canada", la valeur de
# el sera SÉLECTIONNÉE et ajoutée à l'objet Array villes_candiennes.
# La variable el existe seulement dans le bloc de code fourni.
villes_canadiennes = villes.select {|el| el.include?("Canada")}
villes_canadiennes.each {|el| puts el}

# La méthode .sort permet de TRIER les éléments d'un objet Array.
# Le bloc de code encadré par do et end précise comment le tri sera effectué.
# Les variables a et b prendront les valeurs des éléments de l'objet Array au
# cours de l'algorithm de triage.
# Notez que la variable a et b sont encadrés par des lignes verticales | |.
# Ici, on souhaite trier les villes par ordre croissant de température.
# Pour accomplir cela, il faut extraire l'information de l'objet String et
# convertir en nombre (Fixnum) avec la méthode .to_i .
# La méthode .split sépare un objet String en plusieurs éléments. La séparation
# est effectuée selon un autre objet String fourni (";" dans ce cas).
# La méthode .split place les éléments séparés dans un objet Array.
# L'information de la température est située dans la position 2 de l'objet Array
# donnees.
# Le symbole <=> compare deux expressions en Ruby.
villes_par_temp= villes.sort do |a,b|
	donnees = a.split(";")   # donnees est un objet Array qui contient 3 éléments
	temp_a = donnees[2].to_i # .to_i convertit un objet String en un objet Fixnum

	donnees = b.split(";")
	temp_b = donnees[2].to_i

	temp_a <=> temp_b  # Comparons les températures pour les trier
end #Les variables a, b, donnees, temp_a et temp_b n'exsitent plus ...

puts "\nAfficher les villes en ordre de température\n"
villes_par_temp.each {|el| puts el}

puts "\nAfficher les 3 villes les plus froides\n"
villes_par_temp[0..2].each{|el| puts el}

puts "\nAfficher les 3 villes les plus chaudes"
villes_par_temp.reverse[0..2].each {|el| puts el}
# Voici une autre façon de procéder
villes_par_temp.[-3..-1].each {|el| puts el} #Cette façon est plus rapide!

puts "\nAfficher la moyenne de la température"
somme = 0
villes.each { |el|
	donnees = el.split(";")
	temp = donnees[2].to_i
	somme = somme + temp
}

moy = somme.to_f/villes.size  #Pourquoi .to_f?
puts "\nLa moyenne de la temp est :#{moy} C."
