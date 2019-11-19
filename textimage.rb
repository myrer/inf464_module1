class Textimage
  def initialize(nom, ary)
    @nom = nom
     @pixels = Array.new

    ary.each do |str|
      tmp = Array.new
      str.each_char { |chr| tmp.push(chr) }
       @pixels.push(tmp)
    end

  end

  def nom
    return @nom
  end

  def pixels
    return @pixels
  end

  def symboles
    return @pixels.flatten.uniq.sort
  end

  def dimensions
    i = 0
     @pixels.each do |ligne|
      puts "#{i} : #{ligne.size}"
      i = i +  1
    end
  end

  def comparer(autre)
    a = @pixels.flatten
    b = autre.pixels.flatten
    i = 0
    somme = 0
    a.each do |pixel|
       if a[i] == b[i]
         somme = somme + 1
       end
       i = i + 1
    end
    return somme
  end

  def afficher
     @pixels.each do |rangee|
      puts rangee.join("")
    end
  end
end
