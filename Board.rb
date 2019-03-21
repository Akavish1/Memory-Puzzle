require_relative "Card"

class Board

  attr_accessor :board, :rows, :columns

  def initialize(sizes)
    @rows = sizes[0]
    @columns = sizes[1]
    @board = init_empty_board
    populate
  end

  #initializes the matrix with the given size
  def init_empty_board
    Array.new(@rows) {Array.new(@columns){" "}} 
  end

  #checks if generated card value is already on board, used to prevent more than two occurances of the same value
  def already_on_board?(card)
    @board.any? {|arr| arr.any? {|e| e==card}}
  end

  #generates a new card so that if no value given, a random value is generated and if a value is given, generates another card with the same value
  def generate_card(value=nil)
    return Card.new(("A".."Z").to_a.sample) if !value
    Card.new(value)
  end

  #randomly generate coordinates for the spawning of a card, and keep on iterating until empty coordinates were generated
  def generate_coordinates(flag=false)
    loop do 
      new_coords = [rand(0..@rows-1), rand(0..@columns-1)]
      return new_coords if !@board[new_coords[0]][new_coords[1]].is_a?(Card) && !flag 
      return new_coords if flag
    end
  end

  #spawns two cards with the same value at different locations on the board
  def spawn_two_cards(card, coords)
    unless already_on_board?(card)
      @board[coords[0]][coords[1]] = card
      coords2 = generate_coordinates
      @board[coords2[0]][coords2[1]] = generate_card(card.value)
    end
  end

  #populates the board with couples of cards
  def populate
    until @board.all?{|arr| arr.all?{|c| c.is_a?(Card)}}
      spawn_two_cards(generate_card, generate_coordinates)
    end
  end

  #sets up the first line for the render method
  def print_first_line
    puts
    #l33t hax0rs
    (0..@board[0].length-1).each {|e| print " #{e}"}
    puts
  end

  #prints the board so that hidden values are hidden and displayed ones are displayed
  def render
    print_first_line
    @board.each.with_index do |arr, i1|
      print i1
      arr.each.with_index {|e, i2| print "#{e.display} "}
      puts
    end
    puts
  end

  #checks for a win by checking if all cards are face up
  def won?
    @board.all? {|arr| arr.all? {|e| e.face == :up}}
  end

  #reveals card value at a given position
  def reveal(gussed_pos)
    @board[gussed_pos[0]][gussed_pos[1]].reveal
    @board[gussed_pos[0]][gussed_pos[1]]
  end

  #easier access to cards
  def [](pos)
    @board[pos[0]][pos[1]]
  end

end


