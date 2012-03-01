class Strategy
	def initialize(game)
		@game = game
	end

	def sequence_point
		"n"
	end

	def send_boats_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
	end

	def send_boats_people_count(boats)
		# boats will be either :boats_hunting (for walrus-hunting) or :boats_in_vinland (for sending boats to vinland)
	end

	def hunt_seals
	end

	def ivory_to_trade
	end

	def how_much_hay
	end

	def butchering_sheep_count
	end

	def butchering_cows_count
	end	

	def cut_down_trees_count
	end

	def deconstruct_boats_count
	end

	def sheep_move_into_barns_count
	end

	def cows_move_into_barns_count
	end

	def feed_sheep_hay
	end

	def choose_dealer
	end

	def repair_barns_count
	end

	def build_barns_count
	end

	def build_boats_count
	end

	def choose_name
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

	def butchering_sheep_count
		$stdin.gets.chomp.to_i
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

	def choose_name
		$stdin.gets.chomp
	end
end

class DoNothing < Strategy
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

	def butchering_sheep_count
		$stdin.gets.chomp.to_i
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

	def choose_name
		$stdin.gets.chomp
	end
end