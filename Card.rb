class Card

  attr_accessor :value, :face

  #start with face down
  def initialize(value)
    @value = value
    @face = :down
  end

  def display
    @face == :up ? @value : " "
  end

  def reveal
    @face = :up
  end

  def hide
    @face = :down
  end

  def ==(card)
    @value == card.value
  end

end