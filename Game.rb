require_relative "Board"
require_relative "Player"
require_relative "Ai"

class Game

  #sets difficulty
  def get_difficulty
    puts "set the game difficulty - easy (4x3 board), medium (4x4 board), hard (5x4 board) or hard as fuck (6x6 board)"
    loop do
      difficulty = gets.chomp.downcase
      return [4, 3] if difficulty == "easy"
      return [4, 4] if difficulty == "medium"
      return [5, 4] if difficulty == "hard"
      return [6, 6] if difficulty == "hard as fuck"
      puts "Enter easy, medium, hard or hard as fuck"
    end
  end

  #allows to choose a human player or AI player
  def player_or_ai
    puts "Do you want to play yourself, or see the AI play?"
    loop do
      puts "Enter 'player' or 'ai':"
      input = gets.chomp.downcase
      return @player = Player.new if input == "player"
      return @ai = Ai.new if input == "ai"
      puts "Incorrect input"
    end
  end

  #self explanatory
  def initialize
    @board = Board.new(get_difficulty)
    @attempts = 0
    player_or_ai
    @board.render
    play
  end

  #checks if two guesses are a match
  #keeps the cards revealed if its a match, flips them back otherwise
  def is_match?(guess1, guess2)
    if guess1 == guess2
      puts "Its a match!"
      return true
    end
    puts "Mismatch, try again"
    guess1.hide
    guess2.hide
    return false
  end

  #checks if a given board input is in accepted format, within matrix boundaries, and point to a hidden card
  def input_is_valid?(input)
    input.is_a?(Array) && input.length == 2 && input[0] < @board.rows && input[1] < @board.columns && @board[input].face != :up
  end

  #checks if player input is valid according to above criteria
  def validate_player_input
    loop do 
      input = @player.get_input
      return input if input_is_valid?(input)
      puts "Invalid input - x,y format and hidden cards only!" if @player
    end
  end

  #logic for a round of game for a human player
  def round_player
    puts "Enter position of card to flip in format of x,y:"
    guess1 = @board.reveal(validate_player_input)
    @board.render
    puts "Enter second card to flip:"
    guess2 = @board.reveal(validate_player_input)
    @board.render
    is_match?(guess1, guess2)
  end

  #checks if input is not memorized in the AI's hash
  def input_not_in_ai_memory?(input)
    @ai.memory.none? {|k, v| v.include?(input)}
  end

  #checks if ai input is valid according to above criteria
  def validate_ai_input
    loop do
      input = @board.generate_coordinates(true)
      puts "#{input} was generated by the AI"
      return input if input_is_valid?(input) && input_not_in_ai_memory?(input)
    end
  end

  #returns true if two coordinates where popped from AI memory, false if there were no coordinates to pop
  def pop_from_memory?
    input = @ai.generate_input
    if input
      @board.reveal(input[0])
      @board.render
      @board.reveal(input[1])
      @board.render
      is_match?(@board[input[0]], @board[input[1]])
      return true
    end
    false
  end

  #writes two values and their corresponding (new) coordinates two memory
  def write_to_ai_memory(value1, position1, value2, position2)
    @ai.receive_revealed_card(value1, position1)
    @ai.receive_revealed_card(value2, position2)
  end

  #generate two new random guesses for the AI, and check if their values are matched
  #if it isnt a match, then store the cards in AI's memory for future use
  def generate_random_guesses
    position1 = validate_ai_input
    guess1 = @board.reveal(position1)
    @board.render
    position2 = validate_ai_input
    guess2 = @board.reveal(position2)
    @board.render
    result = is_match?(guess1, guess2)
    if !result
      write_to_ai_memory(guess1.value, position1, guess2.value, position2)
    end
  end

  #self explanatory
  def round_ai
    generate_random_guesses if !pop_from_memory?
  end

  #declares the end of the game with the details
  def declare_win(time_to_finish)
    puts "\nVictorious!"
    puts "It took you #{@attempts} attempts and #{time_to_finish} seconds to win a #{@board.rows * @board.columns} slot board\n"
  end

  #the core game logic
  #play a round, increment the attempt counter, count the time from start to end
  def play
    start = Time.now
    until @board.won?
      @player ? round_player : round_ai
      @attempts += 1
      sleep(2)
      system("cls")
      @board.render
    end
    finish = Time.now
    time_to_finish = finish - start
    declare_win(time_to_finish)
  end

end


#run the game
Game.new