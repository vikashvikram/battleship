require 'rails_helper'

RSpec.describe FileParser, type: :parser do
  describe "test cases for File Parsing logic" do
    it "correctly parses the file [1]" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "battleship_data.txt")
      data = FileParser.new(filename)
      expect(data.width).to eq(5)
      expect(data.height).to eq("E")
      expect(data.number_of_ships).to eq(2)
      expect(data.ship_formation_lines).to eq([2,3])
      expect(data.fires).to eq([["A1", "B2", "B2", "B3"], ["A1", "B2", "B3", "A1", "D1", "E1", "D4", "D4", "D5", "D5"]])
    end

    it "correctly parses the file [2]" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "battleship_data2.txt")
      data = FileParser.new(filename)
      expect(data.width).to eq(3)
      expect(data.height).to eq("C")
      expect(data.number_of_ships).to eq(2)
      expect(data.ship_formation_lines).to eq([2,3])
      expect(data.fires).to eq([["A1", "C1", "A1", "B2", "A2", "A3"], ["A4", "B2", "B3", "C1", "C4"]])
    end

    it "raises error that Battle Area is not in correct format of ships are zero" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "incorrect_format.txt")
      expect{FileParser.new(filename)}.to raise_error(RuntimeError, "Battleship Area is not in {Integer} {Alphabet} format or Battleship size is zero")
    end

    it "raises error that Battle Formation line is not in correct format" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "incorrect_format2.txt")
      expect{FileParser.new(filename)}.to raise_error(RuntimeError, "Formation line in correct format at line 3")
    end

    it "raises error that File does not have sufficient info" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "insufficient_info.txt")
      expect{FileParser.new(filename)}.to raise_error(RuntimeError, "File does not have sufficient set of information for Battle")
    end

    it "raises error that Data is not in correct format of Ships are zero" do
      filename = filename = Rails.root.join('spec/fixtures/samples', "zero_ships.txt")
      expect{FileParser.new(filename)}.to raise_error(RuntimeError, "Data not in correct format for Battleship Area or Number of Ships are zero")
    end
  end
end
