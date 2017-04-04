require 'rails_helper'

RSpec.describe Player, type: :model do
  it "initializes correctly" do
    player = Player.new("Player-1", ["A1", "B3"])
    expect(player.name).to eq("Player-1")
    expect(player.shots).to eq(["A1", "B3"])
    expect(player.battleship_positions).to eq({})
    expect(player.battleship_position_count).to eq(0)
  end

  describe "checking for add_position method" do
    before(:each) do
      @player = Player.new("Player-1", ["A1", "B3"])
    end

    it "adds a P type battleship with no prior battleships possession" do
      #add_position(position_type, width, height, location)
      @player.add_position("P", 2, 1, "C1")
      expect(@player.battleship_position_count).to eq(2)
    end

    it "adds a Q type battleship with no prior battleships possession" do
      @player.add_position("Q", 2, 2, "B2")
      expect(@player.battleship_position_count).to eq(4)
    end

    it "adds extra battleships in addition to already existing ones" do
      #add_position(position_type, width, height, location)
      @player.add_position("P", 2, 1, "C1")
      expect(@player.battleship_position_count).to eq(2)
      @player.add_position("Q", 3, 2, "A2")
      expect(@player.battleship_position_count).to eq(8)
    end

    it "checks for duplicate battleships" do
      #add_position(position_type, width, height, location)
      @player.add_position("P", 2, 1, "C1")
      expect(@player.battleship_position_count).to eq(2)
      expect {@player.add_position("Q", 3, 2, "B2")}.to raise_error(RuntimeError, "duplicate position entry C2")
    end
  end

  describe "Tests for initializa_players and validate_player_positions" do

    before(:each) do
      @battle_ground = BattleGround.new(3, "C")
    end

    it "initializes the players successfully" do
      input = ["Q 1 1 B2 A1", "P 2 1 C1 A2"]
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "B1"], ["A3", "B2"]], input: input)
      players = Player.initialize_players(data, @battle_ground)
      expect(players.count).to eq(2)
      expect(players.map(&:name)).to eq(["Player-1", "Player-2"])
      expect(players.first.shots).to eq(["A1", "B1"])
    end

    it "returns position is acquired by more than one player error" do
      input = ["Q 1 1 B2 A1", "P 2 1 C1 B2"]
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "B1"], ["A3", "B2"]], input: input)
      expect {Player.initialize_players(data, @battle_ground)}.to raise_error(RuntimeError, "B2 is acquired by more than one player")
    end

    it "returns does not exist in battle ground error" do
      input = ["Q 1 1 B2 A1", "P 2 1 C1 D4"]
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "B1"], ["A3", "B2"]], input: input)
      expect {Player.initialize_players(data, @battle_ground)}.to raise_error(RuntimeError, "D4 does not exist in battle ground")
    end

  end
end
