class Strategy
	def initialize
	end

	def setup(game, player)
		@game = game
		@player = player
	end

	def sequence_point
		false
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
		# boolean
	end

	def ivory_to_trade
		# int
	end

	def how_much_hay
		# int
	end

	def butcher_sheep 
		# boolean
	end

	def butchering_sheep_count
		# int
	end

	def butcher_cows
		# boolean
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
		# boolean
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
	def sequence_point 
		$stdin.gets.chomp.downcase == 'y'
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
		$stdin.gets.chomp.downcase == 'y'
	end

	def ivory_to_trade
		$stdin.gets.chomp.to_i
	end

	def how_much_hay
		$stdin.gets.chomp.to_i
	end

	def butcher_sheep 
		$stdin.gets.chomp.downcase == 'y'
	end

	def butchering_sheep_count
		$stdin.gets.chomp.to_i
	end

	def butcher_cows
		$stdin.gets.chomp.downcase == 'y'
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
		$stdin.gets.chomp.downcase == 'y'
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
	def initialize
		super
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
		false
	end

	def ivory_to_trade
		0
	end

	def how_much_hay
		0
	end

	def butcher_sheep 
		false
	end

	def butchering_sheep_count
		0
	end

	def butcher_cows
		false
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
		false
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
