class FileParser
  attr_accessor :input, :width, :height, :fires, :number_of_ships, :ship_formation_lines

  def initialize(file_path)
    data = File.read(file_path).upcase
    @input = data.split(/\r|\r\n|\n/)
    initialize_battleship_datapoints
    validate_data
    @width, @height = @battleship_area[0].to_i, @battleship_area[1]
  end

  private

  # runs different validation checks
  def validate_data
    check_data_sufficiency
    check_data_validity
    validate_and_initialize_positions
  end

  # intializes instance variables of the object
  def initialize_battleship_datapoints
    raise "File cannot be parsed since it does not have minimum number of lines" if @input.length < 5
    @battleship_area = @input[0]
    @number_of_ships = @input[1].to_i
    @ship_formation_lines = (2...2+@number_of_ships).to_a
    index = @ship_formation_lines.last
    @fires = []
    NUMBER_OF_PLAYERS.times do |i|
      @fires << (@input[index+i+1].split(" ") || "") if index
    end
  end

  # checks if lines containing infor regarding battle area and number of shots pass badic validation
  # also checks if file contains number of lines required to contain all the information
  def check_data_sufficiency
    if (@battleship_area = @battleship_area.split(" ")).length != 2 or @number_of_ships <= 0
      raise "Data not in correct format for Battleship Area or Number of Ships are zero"
    end
    raise "File does not have sufficient set of information for Battle" if @input.length < (2+@number_of_ships+NUMBER_OF_PLAYERS)
  end

  def check_data_validity
    validate_battleship_area
    validate_number_of_ships
    validate_ship_formation_lines
  end

  # validates the width and height of battle area
  def validate_battleship_area
    x_axis_length = @battleship_area[0]
    y_axis_length = @battleship_area[1]
    if x_axis_length !~ /^\d{1}$/ or y_axis_length !~ /^[A-Z]{1}$/ or x_axis_length.to_i == 0
      raise "Battleship Area is not in {Integer} {Alphabet} format or Battleship size is zero"
    end
  end

  # validates number of ships in battle area
  def validate_number_of_ships
    maximum_number_of_ships_possible = @battleship_area[0].to_i * (@battleship_area[1].ord - 64)
    if @number_of_ships == 0 or NUMBER_OF_PLAYERS*@number_of_ships > maximum_number_of_ships_possible
      raise "Number of ships are either zero or more than maximum number of ships in battle ground"
    end
  end

  # validates the format of battleship formation lines
  def validate_ship_formation_lines
    @ship_formation_lines.each do |i|
      formation = @input[i]
      #TODO: change following line in order to make app support multiple players
      if formation !~ /^[PQ] \d \d [A-Z][1-9] [A-Z][1-9]$/
        raise "Formation line in correct format at line #{i+1}"
      end
    end
  end

  # validated ship formation lines for validity of width and height of ship
  def validate_and_initialize_positions
    @ship_formation_lines.each do |index|
      validate_formation_line_input(index)
    end
  end

  def validate_formation_line_input(index)
    formation_line_input = @input[index].split(" ")
    raise "Insufficient input in the line #{index+1} regarding positions" if formation_line_input.length < (NUMBER_OF_PLAYERS+3)
    raise "Width of Battleship is more than permitted in line #{index+1}" if formation_line_input[1].to_i < 1 or formation_line_input[1].to_i > @battleship_area[0].to_i
    raise "Height of Battleship is more than permitted in line #{index+1}" if formation_line_input[2].to_i < 1 or formation_line_input[1].to_i > (@battleship_area[1].ord - 64)
  end
end
