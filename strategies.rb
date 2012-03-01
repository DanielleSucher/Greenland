class Strategy
	attr_accessor :sequence_point

	def initialize(strategy,game)
		@strategy = strategy
		@game = game
	end

	def sequence_point_yesno
		case @strategy
		when "stdinput"
			$stdin.gets.chomp
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

	def sequence_point_trader
		case @strategy
		when "stdinput"
			$stdin.gets.chomp
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

	def sequence_point_tradee
		case @strategy
		when "stdinput"
			$stdin.gets.chomp
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

	def sequence_point_trade_kind
		case @strategy
		when "stdinput"
			$stdin.gets.chomp
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

	def sequence_point_trade_count
		case @strategy
		when "stdinput"
			$stdin.gets.chomp.to_i
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

	def sequence_point_more_stuff
		case @strategy
		when "stdinput"
			$stdin.gets.chomp
		when "eatallsheep"
			# nom nom sheep
			# can access @game.current_turn and @game.turn.season as needed
		else
			# stdinput, probably, or 
			# puts "You screwed up! Better start again and pick some damn strategies, this time!" and breaks out of the game
		end
	end

end