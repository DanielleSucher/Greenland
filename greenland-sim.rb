$:.unshift File.expand_path('.')
require 'greenland'
require 'strategies'

n1.times do # Edit n1 depending on how many iterations of the game you need for this test!
	sim_game = Game.new

	n2.times { sim_game.players << Player.new } # Edit n2 depending on how many players you need for this test!

	# set player strategies
	sim_game.players.each do |player|
		player.strategy = DoNothing.new(sim_game)
	end

	sim_game.play

	# Need to record results somehow
end