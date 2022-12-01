require_relative 'colors'

class Code_creator
  include Tools
  def initialize
    gets_player_code
    print "Here is the code you created: "
    show_code(@code_created)
    puts
    Pc_guess.new(@code_created)
  end

   # gets the input from the player
  def gets_player_code
    color_create
    @player_choice = []
    print "Write a combination of four colors to create the code or type help for info(ex: blue, w, g r): "
    check_input(@player_choice)
    @code_created = @player_choice
  end
end

class Pc_guess
  include Tools

  def initialize(code)
    @@CODE = code
    @copy_of_code = code.clone
    first_input
  end

  def first_input
    color_create
    @computer_choice = [@blue, @cyan, @green, @red]
    puts
    pc_playground(@computer_choice)  
  end

  def pc_playground(computer_choice)
    create_variable
    tries = 1
    @end = false
    until tries == 100 || @end == true
      puts "Tries n°#{tries}"
      input_exam(computer_choice) if @all_white_two_red == false
      swap_red if @all_white_two_red == true
      tries += 1
    end
    # if @end == false
    #   puts "\nPc lost, your code was good!"
    #   show_code(@@CODE)
    # end
    puts "\nDont use duplicate colors!"
    replay
  end

  def input_exam(computer_choice)
    check_colors(computer_choice, @@CODE, @copy_of_code)    
    check_status(@hint_array, computer_choice)
    computer_choice if @end == false    
  end

  def check_colors(player_input, code, copy_of_code) 
    @@history = []
    check_color(player_input, code, copy_of_code)
  end
  
  def change_position(computer_choice)
    if @hint_array.length < 4
      change_ball(1, computer_choice)
    else
      end_game(@@CODE, @@CODE) if @number_of_red == 4
      computer_choice.shuffle! if @number_of_red <= 1
      return @all_white_two_red = true if @number_of_red == 2   
    end
  end

  def swap_red
    computer_choice = @computer_choice.clone
    @possibilites.each do |comb|
      computer_choice[comb[0]], computer_choice[comb[1]] = computer_choice[comb[1]], computer_choice[comb[0]]
      break @possibilites.delete(comb)            
    end
    check_hints_array(check_colors(computer_choice, @@CODE, @copy_of_code))
    end_game(@@CODE, @@CODE) if @number_of_red == 4
  end

end