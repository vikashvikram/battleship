class Player
  POSITION_COUNT = {"Q" => 2, "P" => 1}
  attr_accessor :shots, :battleship_positions, :battleship_position_count
  attr_reader :name
  def initialize(name, shots)
    @name = name
    @shots = shots
    @battleship_positions = {}
    @battleship_position_count = 0
  end

  # helps a player occupy the given positions on battleground with given type of battleships
  def add_position(position_type, width, height, location)
    x_loc = location[1].to_i
    y_loc = location[0]
    locs = []
    height.times do |i|
      width.times do |j|
        locs << "#{y_loc}#{x_loc+j}"
      end
      y_loc = y_loc.next
    end
    locs.each do |l|
      if @battleship_positions[l]
        raise "duplicate position entry #{l}"
      else
        @battleship_positions[l] = POSITION_COUNT[position_type]
        @battleship_position_count += 1
      end
    end
  end

  # initializes all the players for the given data and prepared battleground
  def self.initialize_players(data, battle_ground)
    players = []
    NUMBER_OF_PLAYERS.times do |i|
      players << Player.new("Player-#{i+1}", data.fires[i])
    end
    data.ship_formation_lines.each do |index|
      formation = data.input[index].split(" ")
      players.each_with_index do |player, i|
        player.add_position(formation[0], formation[1].to_i, formation[2].to_i, formation[3+i])
      end
    end
    validate_player_positions(players, battle_ground)
    return players
  end

  # checks if players occupy a conflicting position or positions that do not exist on battle ground
  def self.validate_player_positions(players, battle_ground)
    positions = {}
    battle_ground_positions = battle_ground.positions
    players.each do |player|
      player.battleship_positions.keys.each do |position|
        if positions[position]
          raise "#{position} is acquired by more than one player"
        elsif !battle_ground_positions[position]
          raise "#{position} does not exist in battle ground"
        else
          positions[position] = true
        end
      end
    end
  end

end
