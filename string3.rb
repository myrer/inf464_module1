t = Time.now #Plaçons la date et l'heure actuelle dans la variable t.
puts t

heures = t.hour #Obtenir les heures
minutes = t.min #Obtenir les minutes

#Ajustons la salutation à l'heure du jour.
if heures < 17
  saluation = "Bonjour!"
else
  saluation =   "Bonsoir!"
end

# La méthode .even? nous indique si un nombre est pair.
if minutes.even? == true
  parite = "pair"
else
  parite = "impair"
end

#Ici, nous effectuons 4 interpolations. Nous encadrons les variables interpolées
#avec les symboles #{ } en rouge.
puts "#{saluation} Il est présentement #{heures} h #{minutes}. Le nombre de minutes est #{parite}."
