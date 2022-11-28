# frozen_string_literal: true

require_relative 'colors'

module Tools
  def help_txt
    color_create
    puts "Here is the rule to play the game:\n
          1)The object of MASTERMIND is to guess a secret code consisting of a series of 4 colored squares.
            Each guest results in feedback narrowing down the possibilities of the code:
            red dots for right color in right position, white dots for right color in a wrong position.\n\n
          2)The color possibilites are: blue #{@blue}, green #{@green}, purple #{@purple}, red #{@red}, cyan #{@cyan} and white #{@white}.\n
            You can even type only the first letter for colors es: 'b' = #{@blue}\n\n
          3)If you still need help type 'colors' or 'rules' when asked for a list of colors or this ruleset!\n\n"
  end

  def asking_help
    print "If you do need help type 'colors', 'rules' or any other key to keep going: "
    help = gets.chomp.capitalize!
    case help
    when 'Colors'
      color_create
      puts "blue #{@blue}, green #{@green}, purple #{@purple}, red #{@red}, cyan #{@cyan} and white #{@white}"
    when 'Rules'
      help_txt
    end
  end

  # initialize the colors
  def color_create
    @blue = '  '.bg_blue
    @green = '  '.bg_green
    @purple = '  '.bg_magenta
    @red = '  '.bg_red
    @cyan = '  '.bg_cyan
    @white = '  '.bg_gray
  end

  private

  # method used to print the code as a line
  def show_code(array)
    array.map { |color| print("#{color} ") }
  end

  # if the game is won it return the phrase and switch the variable to true
  def end_game(code, input)
    puts
    show_code(code)
    show_code(input)
    print'You won nice!!! '
    show_code(code)
    show_code(input)
    puts
    @end = true
  end

  # when the game is over it ask the user for a rematch
  def replay
    print 'Do you wanna play again? y/n: '
    asked_input = gets.chomp.capitalize!.slice(0)
    return unless asked_input == 'Y'

    User_play.new
  end

  def show_history(history)
    n = 1
    puts
    history.each_with_index do |player_input, index|
      next unless index.even?

      puts
      show_code(player_input)
      show_code(history[index + 1])
      puts
      n += 1
    end
  end

  # check for the win or keep going
  def compare_with_code(player_choise, cripted_code)
    return end_game(player_choise, cripted_code) if player_choise == cripted_code

    check_color(player_choise)
  end
end

# class that create an object which contain the code to decript
class Code
  include Tools

  def initialize
    @@number_of_colors = 4
    code_create(@@number_of_colors)
    show_code(@@cripted)
  end

  private

  # create the code
  def code_create(number_of_colors)
    color_create
    @to_be_cripted = [@blue, @green, @purple, @red, @cyan, @white]
    print 'Allow duplicate y/n? '
    duplicate?
    return @@cripted = @to_be_cripted.shuffle.slice(0, number_of_colors) if @duplicate == 'N'

    2.times do
      @to_be_cripted += @to_be_cripted
    end
    @@cripted = @to_be_cripted.shuffle.slice(0, number_of_colors)
  end

  def duplicate?
    @duplicate = gets.chomp.capitalize!.slice(0)
    return unless @duplicate != 'Y' && @duplicate != 'N'

    print 'Type a valid value! '
    duplicate?
  end
end

# cotain the methods that ask useres for input and display them showing the play-ground
class User_play < Code
  include Tools

  @@WHITEBALL = '◉'.gray
  @@REDBALL = '◉'.red

  private

  def initialize
    help_txt
    Code.new
    @@history = []
    @copy_of_cripted = @@cripted.clone
    create_playground
  end

  # ask the user for input
  def create_playground
    print 'How many times do you wanna try to guess? (Enter a number between 1 and 15): '
    get_tries
    @end = false
    until @tries.zero? || @end == true # tries is the difficulty, i will implement a selector for it
      puts "\nYou still have: #{@tries} tries"
      asking_help if @tries.even?
      compare_with_code(gets_player_choise, @@cripted)
      @tries -= 1
    end
    if @end == false
      print "\nYou lost, this was the code: "
      show_code(@@cripted)
      puts ''
    end
    replay
    puts 'It was a pleasure to play with you bye bye !'
  end

  def get_tries
    tries_array = Range.new(1, 15).to_a
    @tries = gets.chomp.to_i
    return if tries_array.include?(@tries)

    puts 'Enter a valid number!'
    get_tries
  end

  def gets_player_choise
    color_create
    @player_choise = []
    @@number_of_colors.times do |n|
      print "Choose what color you wanna place in position #{n + 1}: "
      @player_choise.push(check_input)
    end
    @player_choise
  end

  def check_input
    input = gets.chomp.downcase.slice(0)
    case input
    when 'b'
      puts @blue
      @blue
    when 'r'
      puts @red
      @red
    when 'c'
      puts @cyan
      @cyan
    when 'g'
      puts @green
      @green
    when 'p'
      puts @purple
      @purple
    when 'w'
      puts @white
      @white
    else
      print 'Invalid choise, try another color: '
      check_input
    end
  end

  # gives the user a feedback with hints for the choise he made
  def check_color(player_input)
    hint_array = []
    copy = @copy_of_cripted.clone
    player_input.each_with_index do |color, index| # checks if the current color is in the right place
      if copy.include?(color) && (@@cripted[index] == color)
        copy[index] = '-'
        hint_array.push(@@REDBALL)
      end
      hint_array
    end
    player_input.each do |color| # check if the color is in the code
      if copy.include?(color)        
        hint_array.push(@@WHITEBALL)
        copy.each_with_index { |color_inside, index| break copy.delete_at(index) if color == color_inside }
      end
      hint_array # array which contain the hints
        
    end
    hint_array.shuffle!
    @@history.push(player_input)
    @@history.push(hint_array)
    show_history(@@history)
  end
end

User_play.new
