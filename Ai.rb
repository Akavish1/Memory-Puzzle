class Ai

  attr_accessor :memory

  #initializes the memory has with empty arrays
  def initialize
    @memory = Hash.new {|h, k| h[k] = []}
  end

  #generate an input for the AI to use
  #first priority is popping two coordinates from memory which will surely be a mtch
  #if there are no two coordinates for the same value, then two random coordinates will be generated in the game class
  def generate_input
    @memory.each do |k, v| 
      if v.length == 2
        puts "#{v[0]}, #{v[1]} were popped from memory"
        return @memory.delete(k) 
      end
    end
    nil
  end

  #if two unequal cards were flipped, store the values and coordinates in memory for later use
  def receive_revealed_card(value, coords)
    if !@memory[value].include?(coords)
      puts "#{value} is memorized in coordinates #{coords}"
      @memory[value] << coords 
    end
  end

end