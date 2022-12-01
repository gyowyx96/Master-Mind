# frozen_string_literal: true

class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

module Tools
  WHITEBALL = '◉'.gray
  REDBALL = '◉'.red

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

  def asking_help(input_from_user)
    input_from_user.each do |input|
      case input.capitalize!
      when 'Colors'
        color_create
        puts "blue #{@blue}, green #{@green}, purple #{@purple}, red #{@red}, cyan #{@cyan} and white #{@white}"
      when 'Help'
        help_txt
      end
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

  @@history = []
  # method used to print the code as a line
  def show_code(array)
    array.map { |color| print("#{color} ") }
  end

  # if the game is won it return the phrase and switch the variable to true
  def end_game(code, input)
    puts
    show_code(code)
    show_code(input)
    print 'You won nice!!! '
    show_code(code)
    show_code(input)
    puts
    @end = true
  end

  # when the game is over it ask the user for a rematch
  def replay
    print 'Do you wanna play again? y/n: '
    asked_input = gets.chomp.capitalize!.slice(0)
    return puts 'It was a pleasure to play with you bye bye !' unless asked_input == 'Y'

    PlayerSelector.new
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
  def compare_with_code(player_choice, code, copy_of_code)
    return end_game(player_choice, code) if player_choice == code

    check_color(player_choice, code, copy_of_code)
  end

  # checks the user input and convert it to the colors array
  def check_input(player_choice)
    input = gets.chomp
    input_array = input.split(' ').slice(0, 4)
    if input_array.size == 4
      input_array.each do |i|
        color = i.to_s.slice(0)
        case color
        when 'b'
          @player_choice.push(@blue)
        when 'r'
          @player_choice.push(@red)
        when 'c'
          @player_choice.push(@cyan)
        when 'g'
          @player_choice.push(@green)
        when 'p'
          @player_choice.push(@purple)
        when 'w'
          @player_choice.push(@white)
        end
      end
      if @player_choice.size == 4
        @player_choice
      else
        @player_choice = []
        puts 'Enter a valid combination of colors!'
        check_input(player_choice)
      end
    elsif input_array.include?('help') || input_array.include?('colors')
      asking_help(input_array)
      @player_choice = []
      print "\nChoose the colors you wanna place in your code: "
      check_input(player_choice)

    else
      puts 'Enter a valid combination of colors!'
      check_input(player_choice)
    end
  end

  # gives the user a feedback with hints for the choice he made
  def check_color(player_input, code, copy_of_code)
    @hint_array = []
    copy = copy_of_code.clone
    player_input.each_with_index do |color, index| # checks if the current color is in the right place
      if copy.include?(color) && (code[index] == color)
        copy[index] = '-'
        @hint_array.push(REDBALL)
      end
      @hint_array
    end
    player_input.each do |color| # check if the color is in the code
      if copy.include?(color)
        @hint_array.push(WHITEBALL)
        copy.each_with_index { |color_inside, index| break copy.delete_at(index) if color == color_inside }
      end
    end
    @hint_array.shuffle!
    @@history.push(player_input)
    @@history.push(@hint_array)
    show_history(@@history)
    @hint_array
  end
end

module PcPlayerOnly
  WHITEBALL = '◉'.gray
  REDBALL = '◉'.red

  private

  def create_variable
    color_create
    @all_white_two_red = false
    @reverse_array = []
    @last_choice = []
    @last_red = 0
    @last_color = ''
    @last_hint_length = 0
    @color_to_change = []
    @color_to_pick = [@blue, @green, @purple, @red, @cyan, @white]
    @possibilites = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]
  end

  def check_status(hints, computer_choice)
    if hints.empty?
      computer_choice.each { |color| @color_to_pick.delete(color) if @color_to_pick.include?(color) }
      computer_choice = @color_to_pick.slice(0, 4)
    else
      check_hints_array(hints)
      check_length
      change_position(computer_choice)
      @last_red = @number_of_red
    end
  end

  def check_hints_array(hints)
    @number_of_white = 0
    @number_of_red = 0
    hints.each do |value|
      @number_of_white += 1 if value == WHITEBALL
      @number_of_red += 1 if value == REDBALL
    end
  end

  def check_length
    if @hint_array.length < @last_hint_length
      @color_to_pick.delete(@computer_choice.shift)
      @computer_choice.unshift(@color_to_change.pop)
      @color_to_pick.shuffle!
      @color_to_change.push(@color_to_pick[0])
    end
    @last_hint_length = @hint_array.length
    @color_to_change.uniq!
  end

  def change_ball(computer_choice)
    @color_to_change.push(computer_choice.pop)
    @color_to_pick.each do |color|
      next unless color != @last_color && !computer_choice.include?(color)

      @last_color = color
      @color_to_pick.shuffle!
      return computer_choice.unshift(color)
    end
    @color_to_change.each do |color|
      if color != @last_color && !computer_choice.include?(color)
        @last_color = color
        return computer_choice.unshift(color)
      end
    end
  end
end
