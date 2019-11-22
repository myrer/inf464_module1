
villes =["Dallas;USA;22", "Rome;Italie;21", "La Prairie;Canada;2", "New York;USA;10", "Boston;USA;8",
        "Calgary;Canada;-3","Miami;USA;28","Hong Kong;Chine;24", "Toronto;Canada;5", "Vancouver;Canada;14"]

#Agir sur CHAQUE élément avec la méthode .each
puts "\nToutes les villes\n"
villes.each do |el|
	puts el
end

puts "\nVilles canadiennes\n" 
villes_canadiennes = villes.select {|el| el.include?("Canada")}
villes_canadiennes.each {|el| puts el}

villes_par_temp= villes.sort do |a,b|
	donnees = a.split(";")
	temp_a = donnees[2].to_i
	
	donnees = b.split(";")
	temp_b = donnees[2].to_i
	
	temp_a <=> temp_b
end

puts "\nVilles en ordre de température\n"
villes_par_temp.each {|el| puts el}

puts "\n3 plus froides\n"
villes_par_temp[0,3].each{|el| puts el}

puts "\n3 plus chaudes"
villes_par_temp.reverse[0..2].each {|el| puts el}

somme = 0
villes.each { |el|
	donnees = el.split(";")
	temp = donnees[2].to_i
	somme = somme + temp
}

moy = somme.to_f/villes.size
puts "\nLa moyenne de la temp est :#{moy} C."