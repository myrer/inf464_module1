require_relative "textimage.rb"

def lire(fname)
  ary = Array.new
  f = File.open(fname, "r")
  while ligne = f.gets
    ligne = ligne.chomp
    if ligne.empty?
      puts "empty"
      ligne = " "*10
    end
    if ligne.size > 10
      ligne = ligne[0,10]
    else
      ligne = ligne.ljust(10, " ")
    end
    ary.push(ligne)
  end
  f.close
  return ary
end

#=====
system("clear")

t1 = Textimage.new("t1", lire("t1.txt"))
t2 = Textimage.new("t2", lire("t2.txt"))
t3 = Textimage.new("t3", lire("t3.txt"))
symboles = t1.symboles  +  t2.symboles +  t3.symboles
symboles = symboles.uniq.sort

puts "#{symboles.size}\: #{symboles.join}"

puts t1.nom
t1.afficher
puts
puts t2.nom
t2.afficher
puts
puts t3.nom
t3.afficher

puts t1.comparer(t1)
puts t1.comparer(t2)
puts t2.comparer(t3)
