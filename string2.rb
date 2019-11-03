s =  "Hello, world!"
puts s[2,5]
puts s[2..5]
puts s[-3..-1]

puts s.include?("lo")
puts s.include?("xy")

s =  "2011;Gabriel;Proulx;enseignants"
puts s.split(";")
