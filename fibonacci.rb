def fibonacci(n)
  f0 = 0
  f1 = 1
  n.times do
    tmp = f0 + f1
    puts "#{f0} + #{f1} = #{tmp}"
    f0 = f1
    f1 = tmp
  end
end

fibonacci(100)
