$:.unshift File.expand_path('.')
require 'greenland'
require 'strategies'

# Set up the simulation
puts "How many players should this game have?"
print ">> "
player_count = $stdin.gets.chomp.to_i

strategy_list = []
for i in 0...player_count
	puts "What strategy should Player #{i} use? (StdInput, DoNothing)"
	print ">> "
	strategy = Object.const_get($stdin.gets.chomp).new
	strategy_list << strategy
end

puts "How many iterations of this game do you want to go through?"
print ">> "
game_iterations = $stdin.gets.chomp.to_i

# Set up to record the simulation
games_played = 0
game_results = {}

# Run the simulation
game_iterations.times do
	#Create a new game
	sim_game = GameFactory.game_from_strategies(strategy_list)

	# Set player names
	sim_game.players.each_with_index do |player,i|
		player.name = "Player-#{i}-#{strategy_list[i]}"
	end

	# Play the damn game already!
	sim_game.play

	# Keep track of how many iterations have been run through so far, just in case
	games_played += 1

	# Need to record results somehow
	game_results[games_played] = sim_game.winner_names
end

# Spit out the data
puts "This simulation was run #{games_played} times."
for i in 1..games_played
	if game_results[i] = ""
		puts "In Game #{i}, everyone died."
	else
		puts "In Game #{i}, the winners were: #{game_results[i].join(" and ")}"
	end
end
