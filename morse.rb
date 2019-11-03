lettre_morse = {
  "A" => ".-", "B" => "-...", "C" => "-.-.", "D" => "-..", "E" => ".",
}


def encoder(texte, encodage)
  texte.each_char do |chr|
    print "#{encodage[chr]}  "
  end
end

encoder("ACE", lettre_morse)
puts
