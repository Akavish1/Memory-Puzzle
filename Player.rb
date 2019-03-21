class Player

  #get input from player in format of x,y, x, y or x y
  def get_input
    gets.chomp.split(%r{,|\s}).map{|e| e.to_i}
  end

end