require_relative 'player_play'
require_relative 'computer_play'

class Player_selector
  
  def initialize 
    print "Choose the game mode 1 for Code gusser or 2 for Code creator: "    
    selector
  end

  def selector
    mode_selected = gets.chomp.to_i
    return User_play.new if mode_selected == 1
    return Code_creator.new if mode_selected == 2 
    print 'Invalid entry try again: '
    selector
  end
end
Player_selector.new