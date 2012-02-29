# Greenland: a game for 2-6 players

class Deck
	attr_accessor :cards
end

class YearDeck < Deck
	# (1) succession card, which signals the end of the game
	# (5) warm years (of which one is an expensive walrus year and one a cheap walrus year)
	# (5) cold years (ditto)
	# (10) temperate years (two of each)

	def initialize
		@cards = []
		@cards << { :succession => true}
		@cards << { :temp => "warm", :walrus => "expensive", :succession => false }
		@cards << { :temp => "warm", :walrus => "cheap", :succession => false }
		@cards << { :temp => "cold", :walrus => "expensive", :succession => false }
		@cards << { :temp => "cold", :walrus => "cheap", :succession => false }
		3.times do
			@cards << { :temp => "warm", :walrus => "ordinary", :succession => false }
			@cards << { :temp => "cold", :walrus => "ordinary", :succession => false }
		end
		2.times do
			@cards << { :temp => "temperate", :walrus => "expensive", :succession => false }
			@cards << { :temp => "temperate", :walrus => "cheap", :succession => false }
		end
		6.times do
			@cards << { :temp => "temperate", :walrus => "ordinary", :succession => false }
		end
	end

	def shuffle!
		# Remove the succession card from the year deck.  Shuffle the year
		# deck and divide it into two evenly sized piles.  Put the succession
		# card into one of the piles, reshuffle that pile, and put it beneath
		# the other pile.
		
		# first remove the succession card 
		self.cards.delete( { :succession => true} )
		# then shuffle the remaining 20 cards
		self.cards.shuffle!
		# split the deck in half (2 half decks of 10 cards each)
		half_deck = self.cards[0..9]
		other_half = self.cards[10..19]
		# put the succession card into one of the halves
		other_half << { :succession => true}
		# shuffle that half that now contains the succession card
		other_half.shuffle!
		# put the half with the succession card underneath the first half
		self.cards = half_deck + other_half
		# remember for decks, the first card in the array is the top card
	end
end

class WalrusDeck < Deck
	# (5) good hunting 
	# (5) poor hunting
	# (10) ordinary hunting
	# (1) storm

	def initialize
		@cards = []
		5.times do
			@cards << { :hunting => "good", :storm => false } 
			@cards << { :hunting => "poor", :storm => false } 
		end
		10.times do
			@cards << { :hunting => "ordinary", :storm => false } 
		end
		@cards << { :storm => true }
	end
end

class WinterDeck < Deck
	# (2) It's still winter
	# (1) spring

	def initialize
		@cards = []
		2.times do
			@cards << { :spring => false } 
		end
		@cards << { :spring => true }
	end
end

class SealDeck < Deck
	# (10) seals
	# (1) your hunter dies
	# (1) no seals

	def initialize
		@cards = []
		10.times do
			@cards << { :seals => true, :hunterdies => false } 
		end
		@cards << { :seals => false, :hunterdies => false }
		@cards << { :seals => false, :hunterdies => true }
	end
end



class Player
	attr_accessor :name, :soil_track , :barns, :nursery, :tokens, :barn_animals, :total_points

	# Each player starts with the following tokens: 4 persons, 4 sheep, 1 barn, 1 cow, 1 boat
	# Each player has a SoilTrack, which starts at its most fertile end (99)
	def initialize
		@barns = 1
		@nursery = { :sheep => 0, :cows => 0 } # keeps track of how many cows/sheep are babies and thus don't produce milk each turn/year
		@barn_animals = { :sheep => 0, :cows => 0 } # keeps track of how many cows/sheep are currently living indoors
		@soil_track = 99
			# A soil track for each player, numbered 0-99, with each block of ten
			# marked with a number from 1-10 (the soil fertility level), starts at 99
		@tokens = { :local_people => 4, :sheep => 4, :cows => 1, :boats => 1, :timber => 0,
					:food => 0, :vinland_people => 0, :hunting_people => 0, :busy_people => 0, 
					:boats_in_vinland => 0, :boats_hunting => 0, :hay => 0, :ivory => 0, :silver => 0 }
		@name = ""
		@total_points = 0
	end

	def repair_barn
		# Repair a barn: repairs require one person and one unit of timber.  Any
		# barns not repaired at the end of this phase (midwinter) are destroyed.  
		available_people = self.tokens[:local_people] - self.tokens[:busy_people]
		if available_people >= 1 && self.tokens[:timber] >= 1
			self.tokens[:timber] -= 1
			self.tokens[:busy_people] += 1
			puts "You've repaired a barn!"
		else
			puts "Sorry, you don't have the necessary resources to repair any more barns."
		end
	end

	def build_building(type,people,timber)
		# Build a barn: this requires six people and six units of timber. 
		# Build a boat: this requires three people and three units of timber.
		available_people = self.tokens[:local_people] - self.tokens[:busy_people]
		if available_people >= people && self.tokens[:timber] >= timber
			if type == "barn"
				self.barns += 1
			elsif type == "boat"
				self.tokens[:boats] += 1
			end
			self.tokens[:timber] -= timber
			self.tokens[:busy_people] += people
			puts "You've built a #{type}!"
		else
			puts "Sorry, you don't have the necessary resources to build any more #{type}s."
		end
	end
end



class Turn
	attr_accessor :game, :hunters, :check_for_seals, :ivory_traded, :current_year

	def initialize(game)
		@game = game
		@hunters = []
		@possible_trades = { "people" => :local_people, "sheep" => :sheep, "cows" => :cows, "boats" => :boats, 
							"timber" => :timber, "food" => :food, "hay" => :hay, "ivory" => :ivory, "silver" => :silver }
	end

	def trade(give_or_receive)
		more_stuff = "y"
		while more_stuff == "y"
			puts "What's the next kind of token you're giving as part of this trade? (#{@possible_trades.keys.join(", ")})"
			print ">> "
			kind = $stdin.gets.chomp
			puts "How many #{kind} tokens are you giving?"
			print ">> "
			count = $stdin.gets.chomp.to_i
			give_or_receive[@possible_trades[kind]] = count
			#loop through what kind / what amount until they're done to determine the give_or_receive array
			puts "Do you want to give any other kind of tokens in this trade? (y/n)"
			print ">> "
			more_stuff = $stdin.gets.chomp
		end
	end

	def sequence_point
		# these are the moments in each season (and thus each turn) when players can trade
		puts "Players may trade tokens at this point. Please discuss amongst yourselves."
		puts "Does anyone want to make a trade? (y/n)"
		print ">> "
		another_trade = $stdin.gets.chomp
		while another_trade == "y"
			@give = {}
			@receive = {}
			# figure out what the first player in this trade is trading
			puts "Who is the first player involved in this trade?" 
			print ">> "
			trader_name = $stdin.gets.chomp
			@trader = @game.players.detect { |player| player.name == trader_name }
			self.trade(@give)
			# figure out what the other player in this trade is trading
			puts "Who is the other player involved in this trade?"
			print ">> "
			tradee_name = $stdin.gets.chomp
			@tradee = @game.players.detect { |player| player.name == tradee_name }
			self.trade(@receive)
			# actually make the trade happen, don't just save the data!
			@give.each do |k,v|
				@trader.tokens[k] -= v
				@tradee.tokens[k] += v
				# deliberately not implementing the ability to call back people who were traded away [yet, possibly ever]
			end
			@receive.each do |k,v|
				@trader.tokens[k] += v
				@tradee.tokens[k] -= v
			end
			puts "Does anyone want to make any more trades at this time? (y/n)"
			print ">> "
			another_trade = $stdin.gets.chomp
		end 
		puts "Trading is now over until you hit the next sequence point."
	end

	def send_boats(destination,people,boats)
		puts "Each boat must have at least 2 people on it."
		puts "If you don't send a boat of your own, you may ask other players to carry some of your people."
		puts "A boat can hold up to 10 people."
		@game.players.each do |player|
			if player.tokens[:boats] > 0
				puts "Hey #{player.name}, how many boats do you want to send #{destination} this year?"
				print ">> "
				answer = $stdin.gets.chomp.to_i
				if answer != 0 && answer <= player.tokens[:boats]
					player.tokens[boats] += answer
					player.tokens[:boats] -= answer
					puts "How many people do you want to send #{destination}?"
					puts "(Remember, you have #{player.tokens[:local_people]} people tokens, and must send at least 2 and no more than 10 people per boat.)"
					print ">> "
					count = $stdin.gets.chomp.to_i
					needed = 2 * player.tokens[boats]
					if count >= needed
						player.tokens[:local_people] -= count
						player.tokens[people] += count
						puts "You're sending #{count} people #{destination} this year!"
					else
						puts "Sorry #{player.name}, you didn't send enough people, so your boats couldn't sail."
					end
				else
					puts "Gotcha, no boats #{destination} for you this year!"
				end
			else
				puts "Sorry #{player.name}, you don't have any boats to send #{destination} this year."
			end
		end
	end

	def spring
		puts "Springtime for Hitler, and Vikings, too!"

		self.sequence_point # players can trade tokens
		
		# Each player independently decides if they are going to hunt seals.  
		@game.players.each do |player|
			puts "Hey #{player.name}, do you want to hunt seals this turn? (y/n)"
			print ">> "
			seals = $stdin.gets.chomp
			if seals == "y"
				# Each player who hunts seals puts aside one person token.
				player.tokens[:local_people] -= 1
				player.tokens[:hunting_people] += 1
				@hunters << player.name #test this!
				puts "Okay #{player.name}, you've sent off one of your people to hunt seals!"
			end
		end

		self.sequence_point # players can trade tokens

		# Go around in a circle, starting from the dealer: each player decides
		# if they are going to send a boat to Vinland.  If they do decide to
		# send a boat, they must send at least two of their people on it.
		puts "Spring is a great time to send people to Vinland to fetch precious timber."
		self.send_boats("to Vinland",:vinland_people,:boats_in_vinland)

		self.sequence_point # players can trade tokens

		# Draw a card from the seal hunting deck. If seals are drawn, each
		# player who hunted gains 12 food tokens.  If the hunter dies, discard
		# the person token.  Otherwise, return the seal hunters.
		@game.seal_deck.cards.shuffle!
		@check_for_seals = @game.seal_deck.cards.first

		@game.players.each do |player|
			if @hunters.include?(player.name)
				player.tokens[:hunting_people] = 0
				if @check_for_seals[:hunterdies] == true	
					# don't return the hunter
					# boo no food
					puts "Sorry #{player.name}, your hunter died and you didn't get any food."
				else
					# return the hunter
					player.tokens[:local_people] += 1
					if @check_for_seals[:seals] == true
						# yay food
						player.tokens[:food] += 12
						puts "Hey #{player.name}, your hunter survived AND you got 12 food tokens!"
					else
						# boo no food
						puts "Sorry #{player.name}, you didn't get any food. At least your hunter survived!"
					end
				end
			end
			# test to see what happens to non-hunter players
		end

		@game.players.each do |player|
			# Cows and sheep reproduce: for each sheep token, gain a sheep token;
			# same for cows.  Put the new tokens in the nursery to show that they do
			# not produce milk this year.
			if player.tokens[:sheep] != 0
				player.nursery[:sheep] += player.tokens[:sheep]
				puts "Hey #{player.name}, you have #{player.tokens[:sheep]} new baby sheep!" # when do these animals grow up?
			end
			if player.tokens[:cows] != 0
				player.nursery[:cows] += player.tokens[:cows]
				puts "Hey #{player.name}, you have #{player.tokens[:cows]} new baby cows!" # when do these animals grow up?
			end
			# Each player still in the game gains a person token.
			player.tokens[:local_people] += 1
		end
		puts "Each player got another person token." 
		puts "Congratulations on surviving another spring!"
	end


	def summer
		puts "Summer has come."

		self.sequence_point # players can trade tokens

		# Each player decides if they are going to hunt walrus and
		# how many people they will send.  Hunting walrus requires a boat, and
		# the choosing is run exactly like Vinland.
		puts "Now is the chance to send people walrus-hunting for ivory, useful for trading for silver when ships visit from Norway!"
		self.send_boats("walrus-hunting",:hunting_people,:boats_hunting)

		self.sequence_point # players can trade tokens

		if @game.ship_worth_it == true
			# Except on turn 1, or if the trade ship is on the "not worth it" space:

			# A ship arrives from Norway: players may trade processed ivory tokens
			# for silver at the rate of 1:1 on a cheap year, 1:2 on an ordinary
			# year, and 1:3 on an expensive year.  
			if @current_year[:walrus] == "expensive"
				@exchange_rate = 3
			elsif @current_year[:walrus] == "ordinary"
				@exchange_rate = 2
			else
				@exchange_rate = 1
			end
			puts "A ship has arrived from Norway, seeking to trade their silver for your ivory!"
			puts "This year, they're offering you #{@exchange_rate} silver tokens for each ivory token you give them."
			puts "If you don't collectively trade away at least 3 ivory tokens, the ship won't bother returning next year."

			@ivory_traded = 0
			@game.players.each do |player|
				if player.tokens[:ivory] > 0
					puts "#{player.name}, you currently have #{player.tokens[:ivory]} ivory tokens."
					puts "How many ivory tokens do you want to trade away this year?"
					print ">> "
					ivory_traded = $stdin.gets.chomp.to_i
					if ivory_traded <= player.tokens[:ivory]
						player.tokens[:ivory] -= ivory_traded
						silver_received = @exchange_rate * ivory_traded
						player.tokens[:silver] += silver_received
						@ivory_traded += ivory_traded
						puts "#{player.name}, you now have #{player.tokens[:silver]} silver tokens and #{player.tokens[:ivory]} ivory tokens."
					else
						puts "Sorry #{player.name}, you don't have that much ivory to trade! Sneaky sneaky, no silver for you!"
					end
				else
					puts "Sorry #{player.name}, you don't have any ivory to trade this year."
				end
			end

			# If the players, collectively, do not trade at least 3 ivory, the ship 
			# will not return the next year (move the trade ship to the "not worth it" space).  
			# Trading happens in a circle as per Vinland.
			if @ivory_traded < 3
				puts "You didn't trade enough ivory this year to justify the ship coming all the way from Norway!"
				puts "Norway won't be sending a ship your way next year. It's just not worth it to them!"
				@game.ship_worth_it = false
			end
		else 
			puts "No ship is visiting from Norway with silver to trade this year, because you didn't have enough ivory to trade last year."
			puts "Norway will send a ship to check in on your trading availability again next year, just in case."
			# If the ship didn't stop by this year, set it to stop by next year.
			@game.ship_worth_it = true
		end

		# On a warm year, N=4, a temperate year, N=3, and a cold year, N=2.  
		hay_multiplier = @current_year[:temp]
		if hay_multiplier == "warm"
			hay_multiplier = 4
		elsif hay_multiplier == "cold"
			hay_multiplier = 2
		else
			hay_multiplier = 3
		end
		@game.players.each do |player| 
			# Each player has a soil track, numbered 0-99, with each block of ten
			# marked with a number from 1-10 (the soil fertility level)
			soil_fertility_level = player.soil_track/10
			soil_fertility_level = soil_fertility_level.ceil
				
			# Each player gains up to N hay token per person (who is not in Vinland
			# or hunting walrus) per soil fertility level.  
			new_hay = soil_fertility_level * hay_multiplier * player.tokens[:local_people]
			puts "#{player.name}, you can gain up to #{new_hay} hay tokens this year."
			puts "The more hay you take, the more you damage your soil fertility."
			puts "How many hay tokens do you want to take?"
			print ">> "
			hay_taken = $stdin.gets.chomp.to_i
			if hay_taken <= new_hay
				player.tokens[:hay] += hay_taken
			else
				puts "Tsk, that's more than you are entitled to. Now you get none!"
			end

			# Each cow produces 12 food tokens; each sheep produces 8.
			player.tokens[:food] += 12 * player.tokens[:cows] + 8 * player.tokens[:sheep]

			puts "#{player.name} now has #{player.tokens[:food]} food tokens and #{player.tokens[:hay]} hay tokens."

			# A *single* tree track, numbered 0-99, with each block of ten (0-9,
			# 10-19, ...) marked by a level from 10 (at 0-9) down to 1 (the soil erosion rate)
			soil_erosion_rate = @game.tree_track/10 
			soil_erosion_rate = soil_erosion_rate.floor
			soil_erosion_rate = 10 - soil_erosion_rate

			# Move each player's soil fertility counter down (less fertile) by E * T /3 (rounding up), where
			# E is the soil erosion rate, and T is the number of hay tokens actually taken.
			soil_loss = (soil_erosion_rate * hay_taken) / 3
			player.soil_track-= soil_loss

			puts "#{player.name}'s soil track is now at #{player.soil_track}."
		end
	end

	def autumn
		puts "Autumn has come."

		# Everyone who is in Vinland comes back. 
		puts "All people who were in Vinland have returned." 
		@game.players.each do |player| 
			if player.tokens[:vinland_people] > 0
				# Gain 2 units of timber per person.
				timber_earned = 2 * player.tokens[:vinland_people]
				player.tokens[:timber] +=  timber_earned
				puts "#{player.name} now has #{player.tokens[:timber]} total timber tokens."
				player.tokens[:local_people] += player.tokens[:vinland_people]
				player.tokens[:vinland_people] = 0
			end
		end

		# Everyone who was hunting walrus comes back.  Draw a card from the walrus deck. 
		@game.walrus_deck.cards.shuffle!
		@walrus_year = @game.walrus_deck.cards.first 
		if @walrus_year[:storm] == true
			puts "There was a storm and all walrus hunters and their boats were lost at sea."
			@game.players.each do |player|
				# If the storm card is drawn, all of the people on the walrus boats, and the boats, are returned.
				player.tokens[:hunting_people] = 0
				player.tokens[:boats_hunting] = 0
			end
		else
			puts "Hooray, all hunters made it home safely from the walrus mines!"
			# If it was a good walrus year, each person returns with five ivory tokens; 
			# a bad year, three, an ordinary year, two. (Makes no sense. Changed as per below.)
			if @walrus_year[:hunting] == "ordinary"
				ivory_modifier = 3
			elsif @walrus_year[:hunting] == "good"
				ivory_modifier = 5
			else
				ivory_modifier = 2
			end
			@game.players.each do |player|
				if player.tokens[:hunting_people] > 0
					# Gain ivory_earned units of timber per person sent to hunt walrus.
					ivory_earned = ivory_modifier * player.tokens[:hunting_people]
					player.tokens[:ivory] +=  ivory_earned
					player.tokens[:local_people] += player.tokens[:hunting_people]
					player.tokens[:hunting_people] = 0
					player.tokens[:boats] += player.tokens[:boats_hunting]
					player.tokens[:boats_hunting] = 0
					puts "#{player.name} has earned #{ivory_earned} ivory tokens."
				end
			end
		end

		self.sequence_point # players can trade tokens

		# Players may trade sheep for 12 food tokens each or cows for 18.
		puts "It's time to butcher and set aside meat for before winter hits."
		@game.players.each do |player| 
			puts "Hey #{player.name}, do you want to trade any of your #{player.tokens[:sheep]} sheep for 12 food tokens each? (y/n)"
			print ">> "
			answer = $stdin.gets.chomp
			if answer == "y"
				puts "How many sheep do you want to butcher now?"
				print ">> "
				count = $stdin.gets.chomp.to_i
				player.tokens[:sheep] -= count
				player.tokens[:food] += count*12
			end
			puts "Hey #{player.name}, do you want to trade any of your #{player.tokens[:cows]} cows for 18 food tokens each? (y/n)"
			print ">> "
			answer = $stdin.gets.chomp
			if answer == "y"
				puts "How many cows do you want to butcher now?"
				print ">> "
				count = $stdin.gets.chomp.to_i
				player.tokens[:cows] -= count
				player.tokens[:food] += count*18
			end
			puts "#{player.name} now has #{player.tokens[:food]} total food tokens."
		end

		self.sequence_point # players can trade tokens

		puts "If you need more timber than you can import from Vinland, it's now time to cut down trees or deconstruct boats for wood."
		puts "Each player can cut down 1 tree or deconstruct 1 boat per person token, earning 1 timber token per tree or boat destroyed."
		puts "Remember that if you destroy trees, your land will be less fertile, and if you destroy boats, you won't be able to "
		puts "get to Vinland for timber or hunt walrus for food."
		puts "Of course, you can't repair barns or boats without timber, and your livestock will die in the winter if you lack barns."
		@game.players.each do |player|
			# Players go around in a circle, starting from the dealer, to cut down a
			# tree or deconstruct a boat.  The circle continues until everyone
			# passes; once a player has passed, they may not later decide to cut
			# down a tree.  Each player may cut up to one tree (or deconstruct up to
			# one of their boats) per person token, gaining a timber token and, if
			# cutting a tree, moving the tree counter down one.
			available_people = player.tokens[:local_people] - player.tokens[:busy_people]
			puts "#{player.name}, you have #{available_people} people available to cut down trees or deconstruct boats."
			puts "You currently have #{player.tokens[:timber]} timber tokens."
			puts "How many trees do you want to cut down?"
			print ">> "
			cut_trees = $stdin.gets.chomp.to_i
			if cut_trees > 0
				# cut down trees
				if  cut_trees <= available_people
					cut_trees.times do
						player.tokens[:busy_people] += 1
						player.tokens[:timber] += 1
						@game.tree_track -= 1
					end
					puts "You now have #{player.tokens[:timber]} timber tokens."
					puts "There are only #{@game.tree_track} trees left in all of Greenland."
				else
					puts "Sorry #{player.name}, you don't have enough people to do that work for you!"
				end
			end
			puts "#{player.name}, you have #{available_people} people available to deconstruct boats."
			puts "How many boats do you want to deconstruct?"
			print ">> "
			deconstruct_boats = $stdin.gets.chomp.to_i
			if deconstruct_boats > 0
				if deconstruct_boats <= available_people
					# deconstruct boats 
					deconstruct_boats.times do
						player.tokens[:busy_people] += 1
						player.tokens[:timber] += 1
						player.tokens[:boats] -= 1
					end
					puts "You now have #{player.tokens[:timber]} timber tokens."
				else
					puts "Sorry #{player.name}, you don't have enough people to do that work for you!"
				end
			end
			player.tokens[:busy_people] = 0
		end
	end

	def return_food(multiplier,player)
		food_needed = multiplier * player.tokens[:local_people]
		if player.tokens[:food] >= food_needed
			# Each player returns [multiplier] food tokens per person. 
			player.tokens[:food] -= food_needed
			puts "#{player.name} has #{player.tokens[:food]} food tokens left."
		else
			# If at any time during winter, a player is required to return a food token and 
			# doesn't have one, all of their people die and they are eliminated from the game.
			puts "Sorry #{player.name}, you didn't have enough food, so all your people died and you've been eliminated from the game." 
			@game.players.delete(player)
		end
	end

	def return_hay(cow_multiplier, sheep_multiplier,player)
		cow_hay = cow_multiplier * player.tokens[:cows] 
		sheep_hay = sheep_multiplier * player.tokens[:sheep]
		hay_needed = cow_hay + sheep_hay
		if player.tokens[:hay] >= hay_needed
			player.tokens[:hay] -= hay_needed
			puts "#{player.name} has #{player.tokens[:hay]} hay tokens left."
		else
			# If at any time during the end of winter, a player is required to return hay
			# tokens but does not return one, they must return all of their sheep and cow tokens. 
			player.tokens[:cows] = 0
			player.tokens[:sheep] = 0
			puts "Sorry #{player.name}, you didn't have enough hay, so all your sheep and cows died."
		end
	end

	def early_winter
		puts "Winter is coming."

		#  Remove all the cows and sheep from the nursery.
		@game.players.each do |player|
			player.tokens[:sheep] += player.nursery[:sheep]
			player.tokens[:cows] += player.nursery[:cows]
			player.nursery[:sheep] = 0
			player.nursery[:cows] = 0
			puts "Hey #{player.name}, your livestock have all grown up. You have #{player.tokens[:sheep]} sheep and #{player.tokens[:cows]} cows."
		end

		self.sequence_point # players can trade tokens

		# Each player may move cows and sheep to their barns.  All cows and
		# sheep not in barns are returned.  Each barn can hold 6 animals.
		puts "It's starting to get colder! Only livestock that you can shelter in barns now will survive the coming winter."
		puts "Each of your barns (if you have any!) can hold at most 6 animals."
		@game.players.each do |player|
			capacity = 6 * player.barns
			puts "#{player.name}, you have #{player.barns} barns, which can hold up to #{capacity} animals."
			puts "How many of your #{player.tokens[:sheep]} sheep do you want to move indoors for this winter?"
			print ">> "
			sheep_saved = $stdin.gets.chomp.to_i
			if sheep_saved > capacity
				sheep_saved = capacity
				puts "You can only save up to #{capacity} sheep. Beyond that, you're out of space!"
			end
			player.tokens[:sheep] -= sheep_saved
			player.barn_animals[:sheep] += sheep_saved
			capacity -= sheep_saved
			if capacity > 0
				puts "How many of your #{player.tokens[:cows]} cows do you want to move indoors for this winter?"
				print ">> "
				cows_saved = $stdin.gets.chomp.to_i
				if cows_saved > capacity
					cows_saved = capacity
					puts "You can only save up to #{capacity} cows. Beyond that, you're out of space!"
				end
				player.tokens[:cows] -= cows_saved
				player.barn_animals[:cows] += cows_saved
			end
			puts "You've saved #{player.barn_animals[:sheep]} sheep and #{player.barn_animals[:cows]} cows from the cold!"
			puts "Your remaining #{player.tokens[:sheep]} sheep and #{player.tokens[:cows]} cows are now dead."
			player.tokens[:sheep] = player.barn_animals[:sheep]
			player.tokens[:cows] = player.barn_animals[:cows]
		end

		puts "Your livestock are hungry. You must feed your cows hay."
		puts "You can either feed your sheep hay, or let them graze outside."
		puts "If you don't let your sheep graze outside, your soil will recover by 4 fertility points."
		@game.players.each do |player|
			# Each player either returns three hay tokens for each sheep, or graze their sheep outside.
			puts "#{player.name}, do you want to spend hay tokens to feed your sheep and let your soil recover? (y/n)"
			print ">> "
			answer = $stdin.gets.chomp
			if answer == "y"
				sheep_multiplier = 3
				# If a player does not graze their sheep outside, the soil can recover;
				# their soil fertility counter moves up (more fertile) by 4.
				player.soil_track += 4
			else
				sheep_multiplier = 0
			end			

			# Each player returns six hay tokens for each cow.  
			self.return_hay(6,sheep_multiplier,player)

			# Each player returns three food tokens per person.
			self.return_food(3,player)
		end
	end

	def choose_dealer(chooser)
		puts "Hey #{chooser.name}, you get to choose - who should be the next dealer?"
		print ">> "
		dealer = $stdin.gets.chomp
		i = @game.players.index { |player| player.name == dealer }
		puts "dealer: #{dealer}; i: #{i}"
		@game.players.rotate!(i)
	end

	def mid_winter
		puts "And now we're in the depths of winter."
		
		# Players go around in a circle, starting from the dealer, deciding on
		# building actions.  Each person token may only participate in a single
		# building action.  The building actions are:
 
		puts "Mid-winter is a great time to have your people build or repair barns and boats."
		puts "Each of your people can only work on one building or repair task this year."
		puts "Any barns not repaired will be destroyed by the ravages of winter."
		@game.players.each do |player|
			# Repair a barn: repairs require one person and one unit of timber.  Any
			# barns not repaired at the end of this phase are destroyed.  
			# (Currently not letting players repair other players' barns. Maybe add to rules later.)
			puts "#{player.name}, how many of your #{player.barns} barns do you want to repair this year?"
			print ">> "
			answer = $stdin.gets.chomp.to_i
			if answer != 0
				answer.times do
					player.repair_barn
				end
			end
			player.barns = answer
			# Build a barn: this requires six people and six units of timber.
			puts "#{player.name}, how many barns do you want to build this year?"
			print ">> "
			answer = $stdin.gets.chomp.to_i
			if answer != 0
				answer.times do
					player.build_building("barn",6,6)
				end
			end
			# Build a boat: this requires three people and three units of timber.
			puts "#{player.name}, how many boats do you want to build this year?"
			print ">> "
			answer = $stdin.gets.chomp.to_i
			if answer != 0
				answer.times do
					player.build_building("boat",3,3)
				end
			end
			player.tokens[:busy_people] = 0
		end
		
		self.sequence_point # players can trade tokens

		# Determine which player has the most cows (and thus the highest status)
		@most_cows = @game.players.max_by { |player| player.tokens[:cows] }
		# The player with the most cows (or, in case of a tie, the most sheep,
		# then people, then roll a die), chooses the next dealer.
		@cow_tie = @game.players.select { |player| player.tokens[:cows] == @most_cows.tokens[:cows] }
		if @cow_tie.length > 1
			# use sheep
			@most_sheep = @game.players.max_by { |player| player.tokens[:sheep] }
			@sheep_tie = @game.players.select { |player| player.tokens[:sheep] == @most_sheep.tokens[:sheep] }
			if @sheep_tie.length > 1
				# use people
				@most_people = @game.players.max_by { |player| player.tokens[:local_people] }
				@people_tie = @game.players.select { |player| player.tokens[:local_people] == @most_sheep.tokens[:local_people] }
				if @people_tie.length > 1
					# random
					@game.players.shuffle!
				else
					# stick with people
					self.choose_dealer(@most_people)
				end
			else
				# stick with sheep
				self.choose_dealer(@most_sheep)
			end
		else
			# stick with cows
			self.choose_dealer(@most_cows)
		end
		puts "#{@game.players.first.name} is the new dealer!"
		# Refactor! (recursion?)
	end

	def end_winter
		puts "How long can this winter really last? We'll find out..."

		# Turn up the top winter card. 
		still_winter = @game.winter_deck.cards.first[:spring]

		self.sequence_point # players can trade tokens

		until still_winter == false
			puts "It's STILL winter."

			@game.players.each do |player|
				# If it's still winter, each player returns two hay tokens for each cow
				# and one for each sheep (even if their sheep were previously grazing
				# outside).  
				self.return_hay(2,1,player)

				# If it's still winter, each player returns 1 food token per person token
				self.return_food(1,player)
			end
			# Reshuffle the winter deck. 
			@game.winter_deck.cards.shuffle!
			# Repeat turning up winter cards until the spring card comes up.
			still_winter = @game.winter_deck.cards.first[:spring]
			# Each time a winter card is turned up, each player returns tokens as above.
		end 
	end

	def play
		# Turn up the top year card.  It will determine how productive the
		# fields are this year. 
		@current_year = @game.year_deck.cards.first 
		@game.year_deck.cards.delete_at(0) #delete the top year card, so that the next one down will be on top when the next turn starts
		if @current_year[:succession] == true
			@game.game_over=true
			# If the top card is Succession: return all people to their original
			# owners.  The game is now over and the player with any surviving people
			# and the most silver wins.
		else
			self.spring
			self.summer
			self.autumn
			self.early_winter
			self.mid_winter
			self.end_winter
		end
	end
end



# Greenland: a game for 2-6 players
class Game
	attr_accessor :number_players, :tree_track, :players, :year_deck, :walrus_deck, 
				  :winter_deck, :seal_deck, :game_over, :ship_worth_it, :winners

	def create_decks
		@year_deck = YearDeck.new
		@walrus_deck = WalrusDeck.new
		@winter_deck = WinterDeck.new
		@seal_deck = SealDeck.new
	end

	def initialize
		@game_over = false
		@tree_track = 99
			# A *single* tree track, numbered 0-99, with each block of ten marked by
			# a number from 1-10 (the soil anchoring rate), starts at 99
		@ship_worth_it = false
			# Ship from Norway to trade from ivory. Doesn't show up the first turn, or on later turns where it's not worth it.
		self.create_decks
	end

	def create_players
		@number_players = 0
		until @number_players >= 2 && @number_players < 7
			puts "How many people are playing? (2-6)"
			print ">> "
			@number_players = $stdin.gets.chomp.to_i
			@players = []
			for i in 1..@number_players
				@players << Player.new
			end
		end
	end

	def name_players
		puts "Please decide on unique names for yourselves!"
		@players.each_with_index do |player,i|
			puts "Hey player #{i+1}, what is your name?"
			print ">> "
			player.name = $stdin.gets.chomp
		end
	end

	# Tokens and buildings are public. (presumably meaning that all players can see those belonging to any player? 
	# create methods for checking the game state (and a game state that sums stuff up), maybe?)

	def play
		puts "Welcome to Greenland!"
		puts "The player with the most surviving people and the most silver at the end of the game wins. Good luck!"
		self.create_players
		self.name_players # Have players input their names
		# Choose one player to be the dealer by rolling dice for highest.
		@players.shuffle!
		puts "#{@players.first.name} is the dealer, for now."
		@year_deck.shuffle! # weird shuffle defined in the YearDeck class
		# remember for decks, the first card in the array is the top card
		@turn = Turn.new(self)
		# loop through turns until the succession card is found
		until @game_over == true
			@turn.play
			# moar turns
			@turn = Turn.new(self)
		end
		# When the succession card is revealed, @turn.game_over should become true and the turn will end.
		# The game is now over.
		# deliberately not implementing the ability to call back people who were traded away [yet, possibly ever]
		# Determine how many total points each player has (total count of silver tokens plus person tokens)
		@players.each do |player|
			player.total_points = player.tokens[:silver] + player.tokens[:local_people]
		end
		# The player with any surviving people and the most silver wins.
		@winner = @players.max_by { |player| player.total_points }
		@winners = @players.select { |player| player.total_points == @winner.total_points }
		@winner_names = []
		@winners.each { |player| @winner_names << player.name }
		puts "#{@winner_names.join(" and ")} survived Greenland! Congratulations!"
	end
end