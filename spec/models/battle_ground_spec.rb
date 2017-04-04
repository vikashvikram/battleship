require 'rails_helper'

RSpec.describe BattleGround, type: :model do
  context "Battle Ground should contain all the positions in its height and width" do
    it "contains all the positions" do
      battle_ground = BattleGround.new(4, "C")
      expect(battle_ground.positions.length).to be(12)
      expect(battle_ground.positions.keys).to eq(["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4"])
      expect(battle_ground.positions.values.uniq).to eq([true])
    end
  end
end
