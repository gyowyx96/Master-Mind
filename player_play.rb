# frozen_string_literal: true

require_relative 'colors'

# class that create an object which contain the code to decript
class Code
  include Tools

  def initialize
    @@number_of_colors = 4
    code_create(@@number_of_colors)
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
    @duplicate = gets.chomp.slice(0).downcase
    return unless @duplicate != 'y' && @duplicate != 'n'

    print 'Type a valid value! '
    duplicate?
  end
end

# cotain the methods that ask useres for input and display them showing the play-ground
class User_play < Code
  include Tools

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
    print 'How many times do you wanna try to guess? (Enter a number between 3 and 12): '
    get_tries
    @end = false
    until @tries.zero? || @end == true # tries is the difficulty, i will implement a selector for it
      puts "\nYou still have: #{@tries} tries"
      compare_with_code(gets_player_choice, @@cripted, @copy_of_cripted)
      @tries -= 1
    end
    if @end == false
      print "\nYou lost, this was the code: "
      show_code(@@cripted)
      puts ''
    end
    replay    
  end

  # asks for how many tries it should go on
  def get_tries
    tries_array = Range.new(1, 12).to_a
    @tries = gets.chomp.to_i
    return if tries_array.include?(@tries)

    puts 'Enter a valid number!'
    get_tries
  end

  # gets the input from the player
  def gets_player_choice
    color_create
    @player_choice = []
    print "\nChoose what color you wanna place from left to right in a single line
    (ex: blue, w, g r) or ask for help with 'help' or 'colors': "
    check_input(@player_choice)
    @player_choice
  end
end
