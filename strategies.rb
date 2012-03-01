class Strategy
	def initialize(game)
		@game = game
	end

	def sequence_point
		"n"
		# You can't safely override this other than with $stdin.gets.chomp, so please don't!
	end

	def send_boats_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		# int
	end

	def send_boats_people_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		# int (>= 2*boats sent)
	end

	def hunt_seals
		# y/n
	end

	def ivory_to_trade
		# int
	end

	def how_much_hay
		# int
	end

	def butcher_sheep 
		# y/n
	end

	def butchering_sheep_count
		# int
	end

	def butcher_cows
		# y/n
	end

	def butchering_cows_count
		# int
	end	

	def cut_down_trees_count
		# int
	end

	def deconstruct_boats_count
		# int
	end

	def sheep_move_into_barns_count
		# int
	end

	def cows_move_into_barns_count
		# int
	end

	def feed_sheep_hay
		# y/n
	end

	def choose_dealer
		# name of some player
	end

	def repair_barns_count
		# int
	end

	def build_barns_count
		# int
	end

	def build_boats_count
		# int
	end
end

class StdInput < Strategy
	def initialize(game)
		super(game)
	end

	def sequence_point 
		$stdin.gets.chomp
	end

	def send_boats_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		$stdin.gets.chomp.to_i
	end

	def send_boats_people_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		$stdin.gets.chomp.to_i
	end

	def hunt_seals
		$stdin.gets.chomp
	end

	def ivory_to_trade
		$stdin.gets.chomp.to_i
	end

	def how_much_hay
		$stdin.gets.chomp.to_i
	end

	def butcher_sheep 
		$stdin.gets.chomp
	end

	def butchering_sheep_count
		$stdin.gets.chomp.to_i
	end

	def butcher_cows
		$stdin.gets.chomp
	end

	def butchering_cows_count
		$stdin.gets.chomp.to_i
	end	

	def cut_down_trees_count
		$stdin.gets.chomp.to_i
	end

	def deconstruct_boats_count
		$stdin.gets.chomp.to_i
	end

	def sheep_move_into_barns_count
		$stdin.gets.chomp.to_i
	end

	def cows_move_into_barns_count
		$stdin.gets.chomp.to_i
	end

	def feed_sheep_hay
		$stdin.gets.chomp
	end

	def choose_dealer
		$stdin.gets.chomp
	end

	def repair_barns_count
		$stdin.gets.chomp.to_i
	end

	def build_barns_count
		$stdin.gets.chomp.to_i
	end

	def build_boats_count
		$stdin.gets.chomp.to_i
	end
end

class DoNothing < Strategy
	def initialize(game)
		super(game)
	end

	def send_boats_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		0
	end

	def send_boats_people_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
		0
	end

	def hunt_seals
		"n"
	end

	def ivory_to_trade
		0
	end

	def how_much_hay
		0
	end

	def butcher_sheep 
		"n"
	end

	def butchering_sheep_count
		0
	end

	def butcher_cows
		"n"
	end

	def butchering_cows_count
		0
	end	

	def cut_down_trees_count
		0
	end

	def deconstruct_boats_count
		0
	end

	def sheep_move_into_barns_count
		0
	end

	def cows_move_into_barns_count
		0
	end

	def feed_sheep_hay
		"n"
	end

	def choose_dealer
		@game.players.shuffle.first.name
	end

	def repair_barns_count
		0
	end

	def build_barns_count
		0
	end

	def build_boats_count
		0
	end
end