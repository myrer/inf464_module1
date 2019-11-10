#L'objet villes est un Array.
#Chaque élément de villes est un objet String.
#Chaque élément contient le nom du ville, le pays de cette ville et la
#température le 1er novembre 2019 à midi.
#Notez que la température est aussi un String. Pour traiter cette information
#numériquement, il faudra convertir en nombre entier ( .to_i ).
villes =["Dallas;USA;22", "Rome;Italie;21", "La Prairie;Canada;2", "New York;USA;10", "Boston;USA;8",
        "Calgary;Canada;-3","Miami;USA;28","Hong Kong;Chine;24", "Toronto;Canada;5", "Vancouver;Canada;14"]

#Rappel : Nous avons 10 éléments dans cette liste, villes.size = 10, mais la
# dernière position est 9 (villes.size-1)
dernier_index = villes.size-1

temp_max = 0
ville_max = ""

for index in 0..dernier_index do
  #Example :
  #Quand index sera égal à 0, la méthode .split(";") séparera "Dallas;USA;22"
  #en trois éléments qui seront stockés dans un objet Array nommé donnees.
  #Le point-virgule sert à délimiter chaque élément.
  donnees = villes[index].split(";")
  ville = donnees[0]
  pays = donnees[1]
  temperature = donnees[2].to_i

  puts "Il faisait #{temperature} C dans la ville de #{ville} (#{pays})."
  
  if temperature > temp_max
    temp_max = temperature
    ville_max = ville
  end
end

puts "La ville la plus chaude est #{ville_max} à #{temp_max} C"
