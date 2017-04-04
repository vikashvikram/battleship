require 'rails_helper'

RSpec.describe Battle, type: :model do
  describe "unit tests for Battle model except start method" do
    before(:each) do
      @battle_ground = BattleGround.new(3, "C")
      input = ["Q 1 1 B2 A1", "P 2 1 C1 A2"]
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "C1"], ["A4", "B2"]], input: input)
      @players = Player.initialize_players(data, @battle_ground)
      @battle = Battle.new(@battle_ground, @players)
    end

    it "tests that battle object is initialized correctly" do
      expect(@battle.players.count).to eq(@players.count)
      expect(@battle.battle_ground).to eq(@battle_ground)
      expect(@battle.mapping.keys.length).to eq(@players.map(&:battleship_positions).map(&:keys).flatten.count)
    end

    it "tests that battle is not over when game begins" do
      expect(@battle.over?).to be_falsey
    end

    it "tests that shot to other's position, it is a hit" do
      expect(@battle.hit(@players[0], "A1")).to be_truthy
    end

    it "tests that when shot to own position, it is a miss" do
      expect(@battle.hit(@players[0], "C1")).to be_falsey
    end

    it "tests that when shot outside the battle ground, it is a miss" do
      expect(@battle.hit(@players[1], "D4")).to be_falsey
    end

    it "tests that Q type battleships take two hits to get destroyed" do
      @battle.hit(@players[0], "A1")
      expect{@battle.hit(@players[0], "A1")}.to change{@players[1].battleship_position_count}.from(3).to(2)
    end

    it "tests that when shot to already destroyed ship, it is a miss" do
      @battle.hit(@players[0], "A1")
      @battle.hit(@players[0], "A1")
      expect(@battle.hit(@players[0], "A1")).to be_falsey
    end
  end

  describe "Unit tests for start method" do
    before(:each) do
      @battle_ground = BattleGround.new(3, "C")
      @input = ["Q 1 1 B2 A1", "P 2 1 C1 A2"]
    end

    it "tests that battle is drawn" do
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "C1"], ["A4", "B2"]], input: @input)
      players = Player.initialize_players(data, @battle_ground)
      battle = Battle.new(@battle_ground, players)
      res = battle.start
      expect(res.length).to eq(6)
      expect(res[-1]).to eq("Battle is drawn")
    end

    it "tests that battle is won by player 1" do
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "C1", "A1", "B2", "A2", "A3"], ["A4", "B2", "B3", "C1", "C4"]], input: @input)
      players = Player.initialize_players(data, @battle_ground)
      battle = Battle.new(@battle_ground, players)
      res = battle.start
      expect(res.length).to eq(10)
      expect(res[-1]).to eq("Player-1 won the battle")
    end

    it "tests that battle is won by player 2" do
      data = double("data", ship_formation_lines: [0, 1], fires: [["A1", "C1", "A1", "B2", "A2"], ["A4", "B2", "B3", "C1", "C2", "C5", "B2"]], input: @input)
      players = Player.initialize_players(data, @battle_ground)
      battle = Battle.new(@battle_ground, players)
      res = battle.start
      expect(res.length).to eq(14)
      expect(res[-1]).to eq("Player-2 won the battle")
    end
  end
end

