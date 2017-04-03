class HomeController < ApplicationController
  def home
  end

  def submit
    uploaded_io = params[:battleship_data]
    raise "File must be a .txt file" unless uploaded_io.original_filename.split('.').last == "txt"
    filename = Rails.root.join('tmp', uploaded_io.original_filename)
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    data = FileParser.new(filename)
    battle_ground = BattleGround.new(data.width, data.height)
    players = Player.initialize_players(data, battle_ground)
    battle = Battle.new(battle_ground, players)
    @res = battle.start
  rescue Exception => e
    @err_message = e.message
    render 'home', object: @err_message
  end
end
