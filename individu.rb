class Individu
  def initialize(chromo, fit, ind)
    @chromosome = chromo
    @fitness = fit
    @ind = ind
  end

  def chromosome
    @chromosome
  end

  def fitness
    @fitness
  end

  def ind
    @ind
  end

  def to_s
    "#{@fitness}\t: #{@chromosome.join()}"
  end
end
