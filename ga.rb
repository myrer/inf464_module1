def chromosome_au_hasard(symbols, n)
  chromosome = Array.new
  n.times{ chromosome << symbols.sample}
  return chromosome
end

def afficher_chromosome_1d(c)
    puts c.join
end

def afficher_chromosome_2d(a, col, rang)
  for r in 0..rang-1
    puts a[r*col, col].join("")
  end
end

#=====
#---Hyperparamètres
nombre_chromosomes = 10
colonnes = 13
rangees = 7
longueur_chromosome = colonnes*rangees
symboles = [".", "+"]
str1d = "...*******....*.........*.*..**...**..**.....*.....*.*.........*...*...**..*.....*......*.."
ref = Array.new
str1d.each_char { |chr| ref << chr  }

#---Population initiale
chromosomes = Array.new

nombre_chromosomes.times {
  chromosomes << chromosome_au_hasard(symboles, longueur_chromosome)
}

#Afficher ref
afficher_chromosome_1d(ref)
afficher_chromosome_2d(ref,colonnes,rangees)
puts

chromosomes.each  do |c|
  afficher_chromosome_1d(c)
  afficher_chromosome_2d(c,colonnes,rangees)
  puts
end
