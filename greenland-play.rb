$:.unshift File.expand_path('.')
require 'greenland'
require 'strategies'

game = Game.new
game.create_players
game.name_players

# set player strategies
game.players.each do |player|
	player.strategy = StdInput.new(game)
end

game.play