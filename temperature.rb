temperatures = [7,7,5,-1,4,5,6,12,10,-2,6,7,8,8,6 ]
def maximum(liste)
  max = -999999999999999
  liste.each do |element|
    if element > max
      max = element
    end
  end
  return max
end

def minimum(liste)
  min = 999999999999999
  liste.each do |element|
    if element < min
      min = element
    end
  end
  return min
end

def moyenne(liste)
  somme = 0
  n = 0
  liste.each do |element|
    n = n + 1
    somme = somme + element
  end
  return somme/n
end

puts maximum(temperatures)
puts minimum(temperatures)
puts moyenne(temperatures)
