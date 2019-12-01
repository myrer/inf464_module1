
#Lire les données et les mettre dans un objet Array
nom_fichier = "t4.csv"
eleves = Array.new
f = File.open(nom_fichier, "r")
while ligne = f.gets
	ligne = ligne.chomp
	donnees = ligne.split(";")
	eleves << donnees
end
f.close

eleves.each{|el| puts el.join(" ")}