require 'sinatra/base'
require './lib/game.rb'
require './lib/player.rb'
require './lib/round.rb'
require './lib/rules_handler.rb'
require './lib/opponent.rb'
require './lib/message_log.rb'
require './lib/message_handler.rb'

class RockPaperScissors < Sinatra::Base

  helpers do
    def get_instances
      @game = Game.game_instance
      @round = Round.round_instance
      @message_log = MessageLog.message_log_instance
    end

    def finish_round(player_2_move)
      Round.round_instance.finish_round(player_2_move: player_2_move)
    end
  end

  get '/' do
    erb :enter_names
  end

  post '/names' do
    player_1 = Player.new(name: params[:p1_name])
    player_2 = Player.new(name: params[:p2_name], human: (params[:player_2_type] == 'human'))
    Game.new(player_1: player_1, player_2: player_2)
    message_handler = MessageHandler.new(message_log: MessageLog.new, game: Game.game_instance)
    message_handler.enter_game_message
    Round.round_instance = nil
    redirect '/play'
  end

  get '/play' do
    get_instances
    erb :game
  end

  post '/p1_move' do
    Round.new(player_1_move: params[:p1_choice].to_sym)
    if Game.game_instance.players[:player_2].human == true
      redirect '/play'
    else
      player_2_move = Opponent.choose_move
      finish_round(player_2_move)
      redirect '/results'
    end
  end

  post '/p2_move' do
    finish_round(params[:p2_choice].to_sym)
    redirect '/results'
  end

  get '/results' do
    get_instances
    erb :results
  end

  post '/reset' do
    Round.round_instance = nil
    redirect '/play'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
