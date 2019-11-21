class Individu
  def initialize(chromo, s, ind)
    @chromosome = chromo
    @score = s
    @ind = ind
    @cumul = 0.0
  end

  def to_s
    "#{@score}\t#{@cumul}: #{@chromosome.join()}"
  end

  attr_reader :chromosome, :score, :ind, :cumul
  attr_writer :cumul
end
