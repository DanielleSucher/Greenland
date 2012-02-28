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
	attr_accessor :name, :soil_track , :barns, :nursery, :tokens, :barn_animals

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
					:food => 0, :vinland_people => 0, :hunting_people => 0, :boats_in_vinland => 0, :boats_hunting => 0}
		@name = ""
	end

	def build_barn
	# Build a barn: this requires six people and six units of timber. 
		if self.tokens[:local_people] >= 6 && self.tokens[:timber] >= 6 
			self.barns += 1
			print "You've built a barn!"
		else
			print "Sorry, you don't have the necessary resources to build a barn."
		end
	end

	def build_boat
	# Build a boat: this requires three people and three units of timber.
		if self.tokens[:local_people] >= 3 && self.tokens[:timber] >= 3
			self.tokens[:boats] += 1
			print "You've built a boat!"
		else
			print "Sorry, you don't have the necessary resources to build a boat."
		end
	end

	def repair_barn
		# Repair a barn: repairs require one person and one unit of timber.  Any
		# barns not repaired at the end of this phase (midwinter) are destroyed.  A Player
		# may, with the consent of the other player, repair another player's barn.
		if self.tokens[:local_people] >= 1 && self.tokens[:timber] >= 1
			# what does this really mean?
			print "You've repaired a barn!"
		else
			print "Sorry, you don't have the necessary resources to repair a barn."
		end
	end

	#include all the rules on trading tokens here, or in turn?

	# Trading: Unless otherwise specified, a player may at any sequence
	# point (*) give or trade tokens to any other player.  

	# Trades with immediate
	# effect (i.e. one cow right now for three hay right now) may not be
	# reneged upon; trades with future effect (one cow now for three hay
	# next summer) may be. 

	# The exception is people tokens, which may be
	# given and traded but which the original owner may retrieve any time
	# they are in the settlement (that is, not hunting walrus and not in
	# Vinland)
end



class Turn
	attr_accessor :game

	def initialize(game)
		@game = game
		@hunters = []
	end

	def sequence_point
		# these are the moments in each season (and thus each turn) when players can trade
		print "Players made trade tokens at this point. Please discuss amongst yourselves."
		print "Do anyone want to request a trade? (y/n)"
		another_trade = gets.chomp
		while another_trade == "y"
			# params(other_player, give, receive)
			# give and receive are arrays of tokens
			print "Who if the first player involved in this trade?" 
			trader_name = gets.chomp
				#loop through what kind / what amount until they're done to determine the give array
				#get timing (turns-from-now, season (declare it's the first sequence point in each season for now))
			print "Who is the other player involved in this trade?"
			tradee_name = gets.chomp
				#loop through what kind / what amount until they're done to determine the receive array
				#get timing (turns-from-now, season (declare it's the first sequence point in each season for now))
			print "Do anyone want to request another trade? (y/n)"
			another_trade = gets.chomp
		end 
		print "Trading is now over until you hit the next sequence point."
	end

	def send_boats(destination,people,boats)
		print "Each boat must have at least 2 people on it."
		print "If you don't send a boat of your own, you may ask other players to carry some of your people."
		print "A boat can hold up to 10 people."
		@game.players.each do |player|
			if player.tokens[:boats] > 0
				print "Hey #{player.name}, how many boats do you want to send #{destination} this year?"
				answer = gets.chomp.to_i
				if answer != 0 && answer <= player.tokens[:boats]
					player.tokens[boats] += answer
					player.tokens[:boats] -= answer
					print "How many people do you want to send #{destination}?"
					print "You have #{player.tokens[:local_people]} total, and must send at least 2 and no more than 10 people per boat."
					count = gets.chomp.to_i
					player.tokens[:local_people] -= count
					player.tokens[people] += count
					print "You're sending #{count} people #{destination} this year!"
				else
					print "Gotcha, no boats #{destination} for you this year!"
				end
			else
				print "Sorry #{player.name}, you don't have any boats to send to Vinland this year."
			end
		end
		print "Now that we know which boats are going, if you didn't send a boat of your own, you can request berth on other players' boats."
		print "Discuss amongst yourselves until you come to some agreement."
		# Each player who is not sending a boat
		# may request that another player carry some of their people; they may
		# request this of as many players as they like, in any order; they may
		# take more than one offer.  A boat can hold at most ten people.
	end

	def spring
		print "Springtime for Hitler, and Vikings, too!"

		# * sequence point (can trade)


		# Each player independently decides if they are going to hunt seals.  
		@game.players.each do |player|
			print "Hey #{player.name}, do you want to hunt seals this turn? (y/n)"
			seals = gets.chomp
			if seals == "y"
				# Each player who hunts seals puts aside one person token.
				player.tokens[:local_people] -= 1
				player.tokens[:hunting_people] += 1
				@hunters << player.name #test this!
			end
		end

		# * sequence point (can trade)


		# Go around in a circle, starting from the dealer: each player decides
		# if they are going to send a boat to Vinland.  If they do decide to
		# send a boat, they must send at least two of their people on it.  Go
		# around the circle again: each player who is sending a boat says how
		# many people they are sending.  
		print "Spring is a great time to send people to Vinland for ivory and such."
		self.send_boats("to Vinland",:vinland_people,:boats_in_vinland)

		# * sequence point (can trade)

		# Draw a card from the seal hunting deck. If seals are drawn, each
		# player who hunted gains 12 food tokens.  If the hunter dies, discard
		# the person token.  Otherwise, return the seal hunters.
		@game.seal_deck.cards.shuffle!
		check_for_seals = @game.seal_deck.cards.first

		@game.players.each do |player|
			if @hunters.include?(player.name)
				player.tokens[:hunting_people] = 0
				if check_for_seals[:hunterdies] == true	
					# don't return the hunter
					# boo no food
					print "Sorry #{player.name}, your hunter died and you didn't get any food."
				else
					# return the hunter
					player.tokens[:local_people] += 1
					if check_for_seals[:seals] == true
						# yay food
						player.tokens[:food] += 12
						print "Hey #{player.name}, your hunter survived AND you got 12 food tokens!"
					else
						# boo no food
						print "Sorry #{player.name}, you didn't get any food. At least your hunter survived!"
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
				print "Hey #{player.name}, you have #{player.tokens[:sheep]} new baby sheep!" # when do these animals grow up?
			end
			if player.tokens[:cows] != 0
				player.nursery[:cows] += player.tokens[:cows]
				print "Hey #{player.name}, you have #{player.tokens[:cows]} new baby cows!" # when do these animals grow up?
			end
			# Each player still in the game gains a person token.
			player.tokens[:local_people] += 1
		end
		print "Each player got another person token. Congratulations on surviving another spring!"
	end


	def summer
		print "Summer has come."

		# * sequence point (can trade)

		# Each player decides if they are going to hunt walrus and
		# how many people they will send.  Hunting walrus requires a boat, and
		# the choosing is run exactly like Vinland.
		self.send_boats("walrus-hunting",:hunting_people,:boats_hunting)

		# * sequence point (can trade)

		# Except on turn 1, or if the trade ship is on the "not worth it" space:

		# A ship arrives from Norway: players may trade processed ivory tokens
		# for silver at the rate of 1:1 on a cheap year, 1:2 on an ordinary
		# year, and 1:3 on an expensive year.  If the players, collectively, do
		# not trade at least 3 ivory, the ship will not return the next year
		# (move the trade ship to the "not worth it" space).  Trading happens
		# in a circle as per Vinland.


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
			player.tokens[:hay] += new_hay

			# Each cow produces 12 food tokens; each sheep produces 8.
			player.tokens[:food] += 12 * player.tokens[:cows] + 8 * player.tokens[:sheep]

			print "#{player.name} now has #{player.tokens[:food]} food tokens and #{player.tokens[:hay]} hay tokens."

			# A *single* tree track, numbered 0-99, with each block of ten (0-9,
			# 10-19, ...) marked by a level from 10 (at 0-9) down to 1 (the soil erosion rate)
			soil_erosion_rate = @game.tree_track/10 
			soil_erosion_rate = soil_erosion_rate.floor
			soil_erosion_rate = 10 - soil_erosion_rate

			# Move each player's soil fertility counter down (less fertile) by E * T /3 (rounding up), where
			# E is the soil erosion rate, and T is the number of hay tokens actually taken.
			new_hay = new_hay/3
			soil_loss = soil_erosion_rate * new_hay
			soil_loss = soil_loss.ceil
			player.soil_track-= soil_loss

			print "#{player.name}'s soil track is now at #{player.soil_track}."
		end
	end

	def fall
		print "Autumn has come."

		# Everyone who is in Vinland comes back. 
		print "All of your people who were in Vinland have returned." 
		@game.players.each do |player| 
			if player.tokens[:vinland_people] > 0
				# Gain 2 units of timber per person.
				timber_earned = 2 * player.tokens[:vinland_people]
				player.tokens[:timber] +=  timber_earned
				print "#{player.name} now has #{player.tokens[:timber]} total timber tokens."
				player.tokens[:local_people] += player.tokens[:vinland_people]
				player.tokens[:vinland_people] = 0
			end
		end

		# Everyone who was hunting walrus comes back.  Draw a card from the
		# walrus deck -- if it was a good walrus year, each person returns with
		# five ivory tokens; a bad year, three, an ordinary year, two. (Makes no sense. Changed as per below.)
		
		print "All of your people who were off hunting walrus have returned."
		@game.walrus_deck.cards.shuffle!
		@walrus_year = @game.walrus_deck.cards.first 
		@game.players.each do |player| 
			if player.tokens[:hunting_people] > 0
				ivory_earned = 0
				if @walrus_year[:storm] == true
					# If the storm card is drawn, all of the people on the walrus boats, and the boats, are returned.
					player.tokens[:hunting_people] = 0
					
				else
					if @walrus_year[:hunting] == "ordinary"
						ivory_earned = 3 * player.tokens[:hunting_people]
					elsif @walrus_year[:hunting] == "good"
						ivory_earned = 5 * player.tokens[:hunting_people]
					else
						ivory_earned = 2 * player.tokens[:hunting_people]
					end
				end
				# Gain 2 units of timber per person.
				timber_earned = 2 * player.tokens[:vinland_people]
				player.tokens[:timber] +=  timber_earned
				print "#{player.name} now has #{player.tokens[:timber]} total timber tokens."
				player.tokens[:local_people] += player.tokens[:vinland_people]
				player.tokens[:vinland_people] = 0
			end
		end

		# * sequence point (can trade)

		# Players may trade sheep for 12 food tokens each or cows for 18.
		print "It's time to butcher and set aside meat for before winter hits."
		@game.players.each do |player| 
			print "Hey #{player.name}, do you want to trade any of your #{player.tokens[:sheep]} sheep for 12 food tokens each? (y/n)"
			answer = gets.chomp
			if answer == "y"
				print "How many sheep do you want to butcher now?"
				count = gets.chomp.to_i
				player.tokens[:sheep] -= count
				player.tokens[:food] += count*12
			end
			print "Hey #{player.name}, do you want to trade any of your #{player.tokens[:cows]} cows for 18 food tokens each? (y/n)"
			answer = gets.chomp
			if answer == "y"
				print "How many cows do you want to butcher now?"
				count = gets.chomp.to_i
				player.tokens[:cows] -= count
				player.tokens[:food] += count*18
			end
			print "#{player.name} now has #{player.tokens[:food]} total food tokens."
		end

		# * sequence point (can trade)

		# Players go around in a circle, starting from the dealer, to cut down a
		# tree or deconstruct a boat.  The circle continues until everyone
		# passes; once a player has passed, they may not later decide to cut
		# down a tree.  Each player may cut up to one tree (or deconstruct up to
		# one of their boats) per person token, gaining a timber token and, if
		# cutting a tree, moving the tree counter down one.
	end

	def return_food(multiplier)
		food_needed = multiplier * player.tokens[:local_people]
		if player.tokens[:food] >= food_needed
			# Each player returns [multiplier] food tokens per person. 
			player.tokens[:food] -= food_needed
			print "#{player.name} has #{player.tokens[:food]} food tokens left."
		else
			# If at any time during winter, a player is required to return a food token and 
			# doesn't have one, all of their people die and they are eliminated from the game.
			print "Sorry #{player.name}, you didn't have enough food, so all your people died and you've been eliminated from the game." 
			@game.players.delete(player)
		end
	end

	def return_hay(cow_multiplier, sheep_multiplier)
		hay_needed = cow_multiplier * player.tokens[:cows] + sheep_multiplier * player.tokens[:sheep]
		if player.tokens[:hay] >= hay_needed
			player.tokens[:hay] -= hay_needed
			print "#{player.name} has #{player.tokens[:hay]} hay tokens left."
		else
			# If at any time during the end of winter, a player is required to return hay
			# tokens but does not return one, they must return all of their sheep
			# and cow tokens. 
			player.tokens[:cows] = 0
			player.tokens[:sheep] = 0
			print "Sorry #{player.name}, you didn't have enough hay, so all your sheep and cows died."
		end
	end

	def early_winter
		print "Winter is coming."

		#  Remove all the cows and sheep from the nursery.
		@game.players.each do |player|
			player.tokens[:sheep] += player.nursery[:sheep]
			player.tokens[:cows] += player.nursery[:cows]
			player.nursery[:sheep] = 0
			player.nursery[:cows] = 0
			print "Hey #{player.name}, your livestock is all grown up. You have #{player.tokens[:sheep]} sheep and #{player.tokens[:cows]} cows."
		end

		# * sequence point (can trade)

		# Each player may move cows and sheep to their barns.  All cows and
		# sheep not in barns are returned.  Each barn can hold 6 animals.
		print "It's starting to get colder! Only livestock that you can shelter in barns now will survive the coming winter."
		print "Each of your barns (if you have any!) can hold at most 6 animals."
		@game.players.each do |player|
			capacity = 6 * player.barns
			print "#{player.name}, you have #{player.barns} barns, which can hold up to #{capacity} animals."
			print "How many of your #{player.tokens[:sheep]} sheep do you want to move indoors for this winter?"
			sheep_saved = gets.chomp.to_i
			if sheep_saved > capacity
				sheep_saved = capacity
				print "You can only save up to #{capacity} sheep. Beyond that, you're out of space!"
			end
			player.tokens[:sheep] -= sheep_saved
			players.barn_animals[:sheep] += sheep_saved
			capacity -= sheep_saved
			if capacity > 0
				print "How many of your #{player.tokens[:cows]} cows do you want to move indoors for this winter?"
				cows_saved = gets.chomp.to_i
				if cows_saved > capacity
					cows_saved = capacity
					print "You can only save up to #{capacity} cows. Beyond that, you're out of space!"
				end
				player.tokens[:cows] -= cows_saved
				players.barn_animals[:cows] += cows_saved
			end
			print "You've saved #{player.barn_animals[:sheep]} sheep and #{player.barn_animals[:cows]} cows from the cold!"
			print "Your remaining #{player.tokens[:sheep]} sheep and #{player.tokens[:cows]} cows are now dead."
			player.tokens[:sheep] = 0
			player.tokens[:cows] = 0
		end

		print "Your livestock are hungry. You must feed your cows hay."
		print "You can either feed your sheep hay, or let them graze outside."
		print "If you don't let your sheep graze outside, your soil will recover by 4 fertility points."
		@game.players.each do |player|
			# Each player either returns three hay tokens for each sheep, or graze their sheep outside.
			print "#{player.name}, do you want to spend hay tokens to feed your sheep and let your soil recover? (y/n)"
			answer = gets.chomp
			if answer == "y"
				sheep_multiplier = 3
				# If a player does not graze their sheep outside, the soil can recover;
				# their soil fertility counter moves up (more fertile) by 4.
				player.soil_track += 4
			else
				sheep_multiplier = 0
			end			

			# Each player returns six hay tokens for each cow.  
			self.return_hay(6,sheep_multiplier)

			# Each player returns three food tokens per person.
			self.return_food(3)
		end
	end

	def mid_winter
		print "And now we're in the depths of winter."
		
		# Players go around in a circle, starting from the dealer, deciding on
		# building actions.  Each person token may only participate in a single
		# building action.  The building actions are:

		# Build a barn: this requires six people and six units of timber. 
		print "Mid-winter is a great time to have your people build or repair barns and boats."
		print "Each of your people can only work on one building or repair task this year."
		@game.players.each do |player|
			print "#{player.name}, do you want to build a barn?"
		end

		# Build a boat: this requires three people and three units of timber.

		# Repair a barn: repairs require one person and one unit of timber.  Any
		# barns not repaired at the end of this phase are destroyed.  A Player
		# may, with the consent of the other player, repair another player's barn.

		# * sequence point (can trade)

		# The player with the most cows (or, in case of a tie, the most sheep,
		# then people, then roll a die), chooses the next dealer.
	end

	def end_winter
		print "How long can this winter really last? We'll find out..."

		# Turn up the top winter card. 
		still_winter = @game.winter_deck.cards.first[:spring]

		# * sequence point (can trade)

		until still_winter == false
			print "It's STILL winter."

			@game.players.each do |player|
				# If it's still winter, each player returns two hay tokens for each cow
				# and one for each sheep (even if their sheep were previously grazing
				# outside).  
				self.return_hay(2,1)

				# Each player returns 1 food token per person token
				self.return_food(1)
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
			self.fall
			self.early_winter
			self.mid_winter
			self.end_winter
		end
	end
end



# Greenland: a game for 2-6 players
class Game
	attr_accessor :number_players, :tree_track, :players, :year_deck, :walrus_deck, :winter_deck, :seal_deck, :game_over

	def create_players
		@players = []
		for i in 1..@number_players
			@players << Player.new
		end
	end

	def create_decks
		@year_deck = YearDeck.new
		@walrus_deck = WalrusDeck.new
		@winter_deck = WinterDeck.new
		@seal_deck = SealDeck.new
	end

	def shuffle_decks
		@year_deck.shuffle! # weird shuffle defined in the YearDeck class
		@walrus_deck.cards.shuffle!
		@winter_deck.cards.shuffle!
		@seal_deck.cards.shuffle!
		# remember for decks, the first card in the array is the top card
	end

	def initialize(number_players)
		@number_players = number_players
		@game_over = false
		@tree_track = 99
			# A *single* tree track, numbered 0-99, with each block of ten marked by
			# a number from 1-10 (the soil anchoring rate), starts at 99
		self.create_players
		self.create_decks
		self.shuffle_decks
	end

	def name_players
		print "Please decide on unique names for yourselves!"
		@players.each_with_index do |player,i|
			print "Hey player #{i+1}, what is your name?"
			player.name = gets.chomp
		end
	end

	# Tokens and buildings are public. (presumably meaning that all players can see those belonging to any player? 
	# create methods for checking the game state (and a game state that sums stuff up), maybe?)

	def play
		self.name_players # Have players input their names
		# Choose one player to be the dealer by rolling dice for highest.
		@players.shuffle!
		print "#{@players.first.name} is the dealer, for now."
		@turn = Turn.new(self)
		# loop through turns until the succession card is found
		until @game_over == true
			@turn.play
			# moar turns
			@turn = Turn.new(self)
		end
		# When the succession card is revealed, @turn.game_over should become true and the turn will end.
		# The game is now over.
		# Return all people to their original players. 
		# The player with any surviving people and the most silver wins.
	end
end