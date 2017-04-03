class BattleGround
  attr_accessor :positions
  def initialize(width, height)
    @positions = {}
    ("A"..height).each do |i|
      (1..width).each do |j|
        @positions["#{i}#{j}"] = true
      end
    end
  end
end
