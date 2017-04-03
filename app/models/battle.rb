class Battle
  attr_accessor :battle_ground, :players, :mapping
  def initialize(battle_ground, players)
    @battle_ground = battle_ground
    @players = players
    @mapping = {}
    map_positions_of_players_in_battle_ground
  end

  # Executes the shots of each player one by one according to policy (repeat if hit)
  # returns result if game if drawn or won by a player
  # result is an array of all messages
  def start
    game_over = false
    in_game = {}
    @players.each {|player| in_game[player.name] = true}
    result = []
    until game_over
      @players.each do |player|
        break if game_over
        loop do
          break unless in_game[player.name]
          shot = player.shots.shift
          unless shot
            result << "#{player.name} has no more missiles left to launch"
            in_game[player.name] = false
            break
          end
          res = hit(player, shot)
          unless res
            result << "#{player.name} fires a missile with target #{shot} which got miss"
            break
          end
          result << "#{player.name} fires a missile with target #{shot} which got hit"
          game_over = true if over?
          break if game_over
        end
      end
      game_over = true if over?
    end
    result << conclude
    return result
  end

  # return true if shot hits others' live(a ship that has not been destroyed already) ship
  def hit(player, shot)
    if @mapping[shot] and @mapping[shot] != player
      battleship_owner = @mapping[shot]
      battleship_owner.battleship_positions[shot] -= 1
      if battleship_owner.battleship_positions[shot] == 0
        @mapping[shot] = nil
        battleship_owner.battleship_position_count -= 1
      end
      return true
    else
      return false
    end
  end

  # if all but one player lost all of the ships or every player has fired all the shots
  def over?
    @players.select {|player| player.battleship_position_count != 0}.count == 1 || @players.select {|player| player.shots.length != 0}.count == 0
  end

  # message for the final result of the battle
  def conclude
    if (player = @players.select {|player| player.battleship_position_count != 0}).count == 1
      "#{player[0].name} won the battle"
    else
      "Battle was drawn"
    end
  end

  # reflects which player owns the given position on a battleground
  def map_positions_of_players_in_battle_ground
    @players.each do |player|
      player.battleship_positions.keys.each do |k|
        @mapping[k] = player
      end
    end
  end
end
