# Greenland: a game for 2-6 players
class Game
	attr_accessor :number_players, :treetrack

	validates :number_players, :presence => true, :numericality => { :greater_than => 1, :less_than_or_equal_to => 6 }

	def initialize(number_players)
		@number_players = number_players
		@treetrack = 99
			# A *single* tree track, numbered 0-99, with each block of ten marked by
			# a number from 1-10 (the soil anchoring rate), starts at 99
		self.create_players(@number_players)
		self.create_decks
		self.shuffle_decks
		# Choose one player to be the dealer by rolling dice for highest. @players.choose_dealer? (first define choose_dealer down in Player)
		# the tree counter starts at the most trees (99) end of the tree track.

		# loop through turns until the succession card is found
	end

	def create_players(number_players)
		@players = []
		for i in 1..number_players
			@players << Player.new
		end
	end

	def create_decks
		@yeardeck = YearDeck.new
		@walrusdeck = WalrusDeck.new
		@winterdeck = WinterDeck.new
		@sealdeck = SealDeck.new
	end

	def shuffle_decks
		@yeardeck.shuffle! #still need to define the weird shuffle in the YearDeck class)
		@walrusdeck.cards.shuffle!
		@winterdeck.cards.shuffle!
		@sealdeck.cards.shuffle!
	end

end

class Deck
end

class YearDeck < Deck
	attr_accessible :cards
	# (1) succession card, which signals the end of the game
	# (5) warm years (of which one is an expensive walrus year and one a cheap walrus year)
	# (5) cold years (ditto)
	# (10) temperate years (two of each)

	def initialize
		@cards = []
		@cards << { :temp => "warm", :walrus => "expensive"}
		@cards << { :temp => "warm", :walrus => "cheap"}
		@cards << { :temp => "cold", :walrus => "expensive"}
		@cards << { :temp => "cold", :walrus => "cheap"}
		3.times do
			@cards << { :temp => "warm", :walrus => "ordinary"}
			@cards << { :temp => "cold", :walrus => "ordinary"}
		end
		2.times do
			@cards << { :temp => "temperate", :walrus => "expensive"}
			@cards << { :temp => "temperate", :walrus => "cheap"}
		end
		6.times do
			@cards << { :temp => "temperate", :walrus => "ordinary"}
		end
		@cards << { :succession => true}
	end


	def shuffle!
		# 		Remove the succession card from the year deck.  Shuffle the year
		# deck and divide it into two evenly sized piles.  Put the succession
		# card into one of the piles, reshuffle that pile, and put it beneath
		# the other pile.
		self.cards.shuffle!
		# first remove the succession card 
		# The Year Deck has 21 cards total, so 20 w/o the succession card
		half_deck = self.cards.slice[0..9]
		other_half = self.cards.slice[10..19]
	end
end

class WalrusDeck < Deck
	attr_accessible :cards
	# (5) good hunting 
	# (5) poor hunting
	# (10) ordinary hunting
	# (1) storm

	def initialize
		@cards = []
		5.times do
			@cards << { :hunting => "good" } 
			@cards << { :hunting => "poor" } 
		end
		10.times do
			@cards << { :hunting => "ordinary" } 
		end
		@cards << { :storm => true}
	end
end

class WinterDeck < Deck
	attr_accessible :cards
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
	attr_accessible :cards
	# (10) seals
	# (1) your hunter dies
	# (1) no seals

	def initialize
		@cards = []
		10.times do
			@cards << { :seals => true  } 
		end
		@cards << { :seals => false }
		@cards << { :hunterdies => true }
	end
end

class Player
	attr_accessible :soiltrack , :barns, :tokens

	# Each player starts with the following tokens: 4 persons, 4 sheep, 1 barn, 1 cow, 1 boat
	# Each player has a SoilTrack, which starts at its most fertile end (99)
	def initialize
		@barns = 1
		@soiltrack = 99
			# A soil track for each player, numbered 0-99, with each block of ten
			# marked with a number from 1-10 (the soil fertility level), starts at 99
		@tokens = { :local_people => 4, :sheep => 4, :cows => 1, :boats => 1, :timber => 0, :vinland_people => 0 }
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

	# Tokens and buildings are public. (What does this mean?)

	#include all the rules on trading tokens

	# Trading: Unless otherwise specified, a player may at any sequence
	# point (*) give or trade tokens to any other player.  Trades with immediate
	# effect (i.e. one cow right now for three hay right now) may not be
	# reneged upon; trades with future effect (one cow now for three hay
	# next summer) may be. The exception is people tokens, which may be
	# given and traded but which the original owner may retrieve any time
	# they are in the settlement (that is, not hunting walrus and not in
	# Vinland)
end

# class Strategy < Player
# end

# class EatAllSheep < Strategy
# end

class Turn

	def next_turn
		self.spring
		self.summer
		self.fall
		self.early_winter
		self.mid_winter
		self.end_winter
	end

	def sequence_point
		# these are the moments in each season (and thus each turn) when players can trade
		print "Players made trade tokens at this point. Please discuss amongst yourselves."
		print "Do anyone want to request a trade? (y/n)"
		another_trade = gets.chomp
		while another_trade == "y"
			# params(other_player, give, receive, give_timing, receive_timing)
			# give and receive arrays of tokens
			# timing consists of a Turn (now..now+i) and a sequence point
			print "Who suggested this trade?"
			trader = gets.chomp
				#loop through what kind / what amount until they're done to determine the give array
				#get timing (turns-from-now, season (declare it's the first sequence point in each season for now))
			print "Who is the other person involved in this trade?"
			tradee = gets.chomp
				#loop through what kind / what amount until they're done to determine the receive array
				#get timing (turns-from-now, season (declare it's the first sequence point in each season for now))
			print "Do anyone want to request a trade? (y/n)"
			another_trade = gets.chomp
		end
		print "Trading is now over until you hit the next sequence point."
	end

	def spring
		# Turn up the top year card.  It will determine how productive the
		# fields are this year.  

		# There is intentionally not a sequence point here.

		# If the top card is Succession: return all people to their original
		# owners.  The game is now over and the player with any surviving people
		# and the most silver wins.




		# * sequence point (can trade)

		# Each player independently decides if they are going to hunt seals.  

		# Each player who hunts seals puts aside one person token.

		# * sequence point (can trade)

		# Go around in a circle, starting from the dealer: each player decides
		# if they are going to send a boat to Vinland.  If they do decide to
		# send a boat, they must send at least two of their people on it.  Go
		# around the circle again: each player who is sending a boat says how
		# many people they are sending.  Each player who is not sending a boat
		# may request that another player carry some of their people; they may
		# request this of as many players as they like, in any order; they may
		# take more than one offer.  A boat can hold at most ten people.

		# * sequence point (can trade)

		# Draw a card from the seal hunting deck. If seals are drawn, each
		# player who hunted gains 12 food tokens.  If the hunter dies, discard
		# the person token.  Otherwise, return the seal hunters.

		# Cows and sheep reproduce: for each sheep token, gain a sheep token;
		# same for cows.  Put the new tokens in the nursery to show that they do
		# not produce milk this year.

		# Each player still in the game gains a person token.
	end


	def summer
		# * sequence point (can trade)

		# Each player decides if they are going to hunt walrus and
		# how many people they will send.  Hunting walrus requires a boat, and
		# the choosing is run exactly like Vinland.

		# * sequence point (can trade)

		# Except on turn 1, or if the trade ship is on the "not worth it" space:

		# A ship arrives from Norway: players may trade processed ivory tokens
		# for silver at the rate of 1:1 on a cheap year, 1:2 on an ordinary
		# year, and 1:3 on an expensive year.  If the players, collectively, do
		# not trade at least 3 ivory, the ship will not return the next year
		# (move the trade ship to the "not worth it" space).  Trading happens
		# in a circle as per Vinland.

		# Each player gains up to N hay token per person (who is not in Vinland
		# or hunting walrus) per soil fertility level.  On a warm year, N=4, a
		# temperate year, N=3, and a cold year, N=2.  Move each player's soil
		# fertility counter down (less fertile) by E * T /3 (rounding up), where
		# E is the soil erosion rate, and T is the number of hay tokens actually
		# taken.

		# Each cow produces 12 food tokens; each sheep produces 8.
end

	def fall
		# Everyone who is in Vinland comes back.  

		# Gain 2 units of timber per person.
		for i in 0...Player.count
			Player[i].tokencollection[:timber] += 1
		end


		# Everyone who was hunting walrus comes back.  Draw a card from the
		# walrus deck -- if it was a good walrus year, each person returns with
		# five ivory tokens; a bad year, three, an ordinary year, two.  If the
		# storm card is drawn, all of the people on the walrus boats, and the
		# boats, are returned.

		# * sequence point (can trade)

		# Players may trade sheep for 12 food tokens each or cows for 18.

		# * sequence point (can trade)

		# Players go around in a circle, starting from the dealer, to cut down a
		# tree or deconstruct a boat.  The circle continues until everyone
		# passes; once a player has passed, they may not later decide to cut
		# down a tree.  Each player may cut up to one tree (or deconstruct up to
		# one of their boats) per person token, gaining a timber token and, if
		# cutting a tree, moving the tree counter down one.
	end

	def early_winter
		#  Remove all the cows and sheep from the nursery.

		# * sequence point (can trade)

		# Each player may move cows and sheep to their barns.  All cows and
		# sheep not in barns are returned.  Each barn can hold 6 animals.

		# Each player returns six hay tokens for each cow.  They may also return
		# three hay tokens for each sheep, or graze their sheep outside.

		# If a player does not graze their sheep outside, the soil can recover;
		# their soil fertility counter moves up (more fertile) by 4.

		# Each player returns three food tokens per person.
	end

	def mid_winter
		# Players go around in a circle, starting from the dealer, deciding on
		# building actions.  Each person token may only participate in a single
		# building action.  The building actions are:

		# Repair a barn: repairs require one person and one unit of timber.  Any
		# barns not repaired at the end of this phase are destroyed.  A Player
		# may, with the consent of the other player, repair another player's barn.

		# Build a barn: this requires six people and six units of timber. 
		print "Who wants to build a barn?"

		# Build a boat: this requires three people and three units of timber.

		# * sequence point (can trade)

		# The player with the most cows (or, in case of a tie, the most sheep,
		# then people, then roll a die), chooses the next dealer.
	end

	def end_winter
		# Turn up the top winter card.  

		# * sequence point (can trade)

		# If it's still winter, each player returns two hay tokens for each cow
		# and one for each sheep (even if their sheep were previously grazing
		# outside).  Each player returns one food token per
		# person. 

		# Reshuffle the winter deck. 
		# Repeat turning up winter cards until the spring card comes up.
		# Each time a winter card is turned up, each player returns tokens as above.

		# If at any time during the end of winter, a player is required to return hay
		# tokens but does not return one, they must return all of their sheep
		# and cow tokens.  If they are required to return a food token and don't
		# have one, all of their people die and they are eliminated from the
		# game.  
	end

	def end_winter_return_tokens
		@players.each do
			# something, surely
		end
	end
end








