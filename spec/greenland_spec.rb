$:.unshift File.expand_path('.')
require 'greenland'
require 'input_faker'

describe Game do

	describe "New Game" do
		before(:each) do
			@game = Game.new
		end

		it "should have a tree track starting at 99" do
			@game.tree_track.should == 99
		end

		it "shouldn't deem a ship from vinland worth it on the first turn" do
			@game.ship_worth_it.should == false
		end

		describe "Decks" do
			it "should have a Year Deck" do
				@game.should respond_to(:year_deck)
			end

			it "should have 21 cards in its Year Deck" do
				@game.year_deck.cards.size.should == 21
			end

			it "should have a Walrus Deck" do
				@game.should respond_to(:walrus_deck)
			end

			it "should have 21 cards in its Walrus Deck" do
				@game.walrus_deck.cards.size.should == 21
			end

			it "should have a Winter Deck" do
				@game.should respond_to(:winter_deck)
			end

			it "should have 3 cards in its Winter Deck" do
				@game.winter_deck.cards.size.should == 3
			end

			it "should have a Seal Deck" do
				@game.should respond_to(:seal_deck)
			end

			it "should have 12 cards in its Seal Deck" do
				@game.seal_deck.cards.size.should == 12
			end
		end
	end

	describe "Play Game" do

		before(:each) do
			@game = Game.new
		end

		it "should create players properly" do
			InputFaker.with_fake_input(["1","3"]) do
				@game.create_players
				@game.number_players.should be == 3
				@game.players.length.should be == 3
			end
		end

		it "should name players properly" do
			InputFaker.with_fake_input(["3","Ann","Ben","Cat"]) do
				@game.create_players
				@game.name_players
				@game.players.length.should be == 3
				@game.players[0].name.should be == "Ann"
				@game.players[1].name.should be == "Ben"
				@game.players[2].name.should be == "Cat"
			end
		end

		it "should end the game when the succession card comes up" do
			InputFaker.with_fake_input(["3","Ann","Ben","Cat"]) do
				@game.game_over = true
				@game.play
				@game.players.length.should be == 3
				@game.winners.length.should be == 3
				@game.winners.should include(@game.players[0])
				@game.winners.should include(@game.players[1])
				@game.winners.should include(@game.players[2])
			end
		end
	end
end

describe Deck do
	describe YearDeck do
		before(:each) do 
			@year_deck = YearDeck.new
		end

		it "should have 21 cards" do
			@year_deck.cards.size.should == 21
		end

		it "should have 1 succession card" do
			@year_deck.cards.count( { :succession => true } ).should == 1
		end

		it "should shuffle the succession card into the bottom half of the deck" do
			@year_deck.shuffle!
			@year_deck.cards.index( { :succession => true } ).should >= 10
		end

		it "should have 6 temperate weather / ordinary walrus cards" do
			@year_deck.cards.count( { :temp => "temperate", :walrus => "ordinary", :succession => false  } ).should == 6
		end

		it "should have 2 temperate weather / expensive walrus cards" do
			@year_deck.cards.count( { :temp => "temperate", :walrus => "expensive", :succession => false  } ).should == 2
		end

		it "should have 2 temperate weather / cheap walrus cards" do
			@year_deck.cards.count( { :temp => "temperate", :walrus => "cheap", :succession => false  } ).should == 2
		end

		it "should have 3 warm weather / ordinary walrus cards" do
			@year_deck.cards.count( { :temp => "warm", :walrus => "ordinary", :succession => false  } ).should == 3
		end

		it "should have 1 warm weather / expensive walrus card" do
			@year_deck.cards.count( { :temp => "warm", :walrus => "expensive", :succession => false  } ).should == 1
		end

		it "should have 1 warm weather / cheap walrus card" do
			@year_deck.cards.count( { :temp => "warm", :walrus => "cheap", :succession => false  } ).should == 1
		end

		it "should have 3 cold weather / ordinary walrus cards" do
			@year_deck.cards.count( { :temp => "cold", :walrus => "ordinary", :succession => false  } ).should == 3
		end

		it "should have 1 cold weather / expensive walrus card" do
			@year_deck.cards.count( { :temp => "cold", :walrus => "expensive", :succession => false  } ).should == 1
		end

		it "should have 1 cold weather / cheap walrus card" do
			@year_deck.cards.count( { :temp => "cold", :walrus => "cheap", :succession => false  } ).should == 1
		end
	end

	describe WalrusDeck do
		before(:each) do 
			@walrus_deck = WalrusDeck.new
		end

		it "should have 21 cards" do
			@walrus_deck.cards.size.should == 21
		end

		it "should have 1 storm card" do
			@walrus_deck.cards.count( { :storm => true } ).should == 1
		end

		it "should have 10 ordinary hunting cards" do
			@walrus_deck.cards.count( { :hunting => "ordinary", :storm => false } ).should == 10
		end

		it "should have 5 good hunting cards" do
			@walrus_deck.cards.count( { :hunting => "good", :storm => false } ).should == 5
		end

		it "should have 5 poor hunting cards" do
			@walrus_deck.cards.count( { :hunting => "poor", :storm => false } ).should == 5
		end
	end

	describe WinterDeck do
		before(:each) do 
			@winter_deck = WinterDeck.new
		end

		it "should have 3 cards" do
			@winter_deck.cards.size.should == 3
		end

		it "should have 2 not-spring-yet cards" do
			@winter_deck.cards.count( { :spring => false } ).should == 2
		end

		it "should have 1 spring card" do
			@winter_deck.cards.count( { :spring => true } ).should == 1
		end
	end

	describe SealDeck do
		before(:each) do 
			@seal_deck = SealDeck.new
		end

		it "should have 12 cards" do
			@seal_deck.cards.size.should == 12
		end

		it "should have 10 seal cards" do
			@seal_deck.cards.count( { :seals => true, :hunterdies => false } ).should == 10
		end

		it "should have 1 no-seal card" do
			@seal_deck.cards.count( { :seals => false, :hunterdies => false } ).should == 1
		end

		it "should have 1 hunter-dies card" do
			@seal_deck.cards.count( { :seals => false, :hunterdies => true } ).should == 1
		end
	end
end

describe Player do

	describe "New Player" do
	
		before(:each) do 
			@player = Player.new
		end

		it "should start with a soil track starting at 99" do
			@player.soil_track.should == 99
		end

		it "should start with 1 barn" do
			@player.barns.should == 1
		end

		it "should start with no baby sheep" do
			@player.nursery[:sheep].should == 0
		end

		it "should start with no baby cows" do
			@player.nursery[:cows].should == 0
		end

		it "should start with no sheep living indoors" do
			@player.barn_animals[:sheep].should == 0
		end

		it "should start with no cows living indoors" do
			@player.barn_animals[:cows].should == 0
		end

		it "should have a blank name" do
			@player.name.should == ""
		end

		it "should have no total endgame points" do
			@player.total_points.should == 0
		end

		describe "Starting Tokens" do
			it "should start with a set of tokens" do
				@player.should respond_to(:tokens)
			end

			it "should start with 4 people tokens" do
				@player.tokens[:local_people].should == 4
			end

			it "should start with no people in vinland" do
				@player.tokens[:vinland_people].should == 0
			end

			it "should start with no people hunting" do
				@player.tokens[:hunting_people].should == 0
			end

			it "should start with no people working on anything" do
				@player.tokens[:busy_people].should == 0
			end

			it "should start with 4 sheep tokens" do
				@player.tokens[:sheep].should == 4
			end

			it "should start with 1 cow token" do
				@player.tokens[:cows].should == 1
			end

			it "should start with 1 boat token" do
				@player.tokens[:boats].should == 1
			end

			it "should start with no boats in vinland" do
				@player.tokens[:boats_in_vinland].should == 0
			end

			it "should start with no boats in off hunting" do
				@player.tokens[:boats_hunting].should == 0
			end

			it "should start with 0 timber tokens" do
				@player.tokens[:timber].should == 0
			end

			it "should start with 0 food tokens" do
				@player.tokens[:food].should == 0
			end

			it "should start with 0 ivory tokens" do
				@player.tokens[:ivory].should == 0
			end

			it "should start with 0 hay tokens" do
				@player.tokens[:hay].should == 0
			end

			it "should start with 0 silver tokens" do
				@player.tokens[:silver].should == 0
			end
		end
	end
end

describe Turn do

	before(:each) do 
			@game = Game.new
			@game.players = []
			3.times { @game.players << Player.new }
			@game.players[0].name = "Ann"
			@game.players[1].name = "Ben"
			@game.players[2].name = "Cat"
			@game.players.shuffle!
			@turn = Turn.new(@game)
	end

	describe "New Turn" do

		it "should default to the game not being over yet" do
			@turn.game.game_over.should == false
		end

		it "should become game_over==true when the succession card is revealed" do
			@turn.game.year_deck.cards.delete( { :succession => true} )
			@turn.game.year_deck.cards.unshift( { :succession => true} )
			@turn.play
			@turn.game.game_over.should be == true
			@game.game_over.should be == true
		end

		it "should access the game's instance variables" do
			@turn.game.players << Player.new
			@turn.game.players[3].name = "Dave"
			@game.players[3].name.should == "Dave"
		end
	end

	describe "Sequence Point" do

		it "should allow trading to happen" do
			InputFaker.with_fake_input(["y","Ann","sheep","1","n","Ben","cows","1","n","n"]) do
				@turn.game.players[0].name = "Ann"
				@turn.game.players[1].name = "Ben"
				@turn.game.players[2].name = "Cat"
				@turn.sequence_point
				@turn.game.players[0].tokens[:sheep].should be == 3
				@turn.game.players[0].tokens[:cows].should be == 2
				@turn.game.players[1].tokens[:sheep].should be == 5
				@turn.game.players[1].tokens[:cows].should be == 0
			end
		end
	end

	describe "Spring" do

		it "should allow for vinland-sailing, seal-hunting, and babies" do
			InputFaker.with_fake_input(["n","n","n","y","n","1","2","0","0","n"]) do
				@turn.spring
				# Player 3 should send someone off to hunt seal
				@turn.hunters.should include(@turn.game.players[2].name)
				# The other plays should not send anyone off to hunt seal
				@turn.hunters.should_not include(@turn.game.players[0].name)
				@turn.hunters.should_not include(@turn.game.players[1].name)
				# Player 1 should send 2 people and 1 boat to Vinland.
				@turn.game.players[0].tokens[:local_people].should be == 3 
				@turn.game.players[0].tokens[:vinland_people].should be == 2
				@turn.game.players[0].tokens[:boats].should be == 0
				@turn.game.players[0].tokens[:boats_in_vinland].should be == 1
				# Player 2 shouldn't send anyone to Vinland.
				@turn.game.players[1].tokens[:local_people].should be == 5
				@turn.game.players[1].tokens[:vinland_people].should be == 0
				@turn.game.players[1].tokens[:boats].should be == 1
				@turn.game.players[1].tokens[:boats_in_vinland].should be == 0
				# Player 3 should get the right results from seal-hunting
				# if @turn.check_for_seals[:hunterdies] == true
				# 	@turn.game.players[2].tokens[:local_people].should be == 4
				# else
				# 	@turn.game.players[2].tokens[:local_people].should be == 5
				# 	if @check_for_seals[:seals] == true
				# 		@turn.game.players[2].tokens[:food].should be == 12
				# 	else
				# 		@turn.game.players[2].tokens[:food].should be == 0
				# 	end
				# end
				# Non-hunting players should earn no food no matter what
				@turn.game.players[0].tokens[:food].should be == 0
				@turn.game.players[1].tokens[:food].should be == 0
				# all players should gain 1 baby sheep or cow per adult of each
				@turn.game.players[0].nursery[:sheep].should be == 4
				@turn.game.players[0].nursery[:cows].should be == 1
				@turn.game.players[1].nursery[:sheep].should be == 4
				@turn.game.players[1].nursery[:cows].should be == 1
				@turn.game.players[2].nursery[:sheep].should be == 4
				@turn.game.players[2].nursery[:cows].should be == 1
			end
		end
	end

	describe "Summer" do

		before(:each) do
			@turn.current_year = { :temp => "warm" }
		end

		it "should allow for walrus-hunting" do
			InputFaker.with_fake_input(["n","0","1","2","0","n","0","0","0"]) do
				@turn.summer
				@turn.game.players[1].tokens[:boats].should be == 0
				@turn.game.players[1].tokens[:boats_hunting].should be == 1
				@turn.game.players[0].tokens[:boats].should be == 1
				@turn.game.players[0].tokens[:boats_hunting].should be == 0
				@turn.game.players[2].tokens[:boats].should be == 1
				@turn.game.players[2].tokens[:boats_hunting].should be == 0
			end
		end

		it "not have a ship from Norway on the first turn" do
			InputFaker.with_fake_input(["n","0","0","0","n","0","0","0"]) do
				@turn.summer
				@game.ship_worth_it.should be == true # should set it to true after a year when it was false
				@turn.ivory_traded.should be_nil
			end
		end

		it "should allow for ivory-trading" do
			InputFaker.with_fake_input(["n","0","0","0","n","1","2","0","0","0"]) do
				@game.ship_worth_it = true
				@turn.game.players[1].tokens[:ivory] = 1
				@turn.game.players[2].tokens[:ivory] = 1
				@turn.summer
				@turn.game.players[1].tokens[:ivory].should be == 0
				@turn.game.players[1].tokens[:silver].should be > 0
				@turn.game.players[2].tokens[:ivory].should be == 1
				@turn.game.players[2].tokens[:silver].should be == 0
				@turn.game.players[0].tokens[:ivory].should be == 0
				@turn.game.players[0].tokens[:silver].should be == 0
				@game.ship_worth_it.should be == false
			end
		end

		it "should effect the correct hay/soil repercussions" do
			InputFaker.with_fake_input(["n","0","0","0","n","0","5","30"]) do
				@turn.summer
				@turn.game.players[0].tokens[:hay].should be == 0
				@turn.game.players[1].tokens[:hay].should be == 5
				@turn.game.players[2].tokens[:hay].should be == 30
				@turn.game.players[0].soil_track.should be == 99
				@turn.game.players[1].soil_track.should be == 98
				@turn.game.players[2].soil_track.should be == 89
			end
		end
	end

	describe "Autumn" do

		it "should return people previously sent to Vinland" do
			InputFaker.with_fake_input(["n","n","n","n","y","1","y","2","n","n","2","0","1","0","0","1"]) do
				@turn.game.players[0].tokens[:vinland_people] = 1
				@turn.autumn
				@turn.game.players[0].tokens[:vinland_people].should be == 0
				@turn.game.players[0].tokens[:local_people].should be == 5
				@turn.game.players[1].tokens[:local_people].should be == 4
			end
		end

		it "should kill all hunters if there was a storm" do
			InputFaker.with_fake_input(["n","n","n","n","y","1","y","2","n","n","2","0","1","0","0","1"]) do
				@game.walrus_deck.cards = [ { :storm => true } ]
				@turn.game.players[0].tokens[:hunting_people] = 1
				@turn.game.players[0].tokens[:local_people] = 3
				@turn.autumn
				@turn.game.players[0].tokens[:hunting_people].should be == 0
				@turn.game.players[0].tokens[:local_people].should be == 3
				@turn.game.players[1].tokens[:local_people].should be == 4
			end
		end

		it "should give hunters the right amount of ivory" do
			InputFaker.with_fake_input(["n","n","n","n","y","1","y","2","n","n","2","0","1","0","0","1"]) do
				@turn.game.walrus_deck.cards = [ { :hunting => "good" } ]
				@turn.game.players[0].tokens[:hunting_people] = 1
				@turn.game.players[0].tokens[:local_people] = 3
				@turn.autumn
				@turn.game.players[0].tokens[:hunting_people].should be == 0
				@turn.game.players[0].tokens[:local_people].should be == 4
				@turn.game.players[0].tokens[:ivory].should be == 5
				@turn.game.players[1].tokens[:local_people].should be == 4
				@turn.game.players[1].tokens[:ivory].should be == 0
			end
		end

		it "should handle butchering correctly" do
			InputFaker.with_fake_input(["n","n","n","n","y","1","y","2","n","n","2","0","1","0","0","1"]) do
				@turn.autumn
				# butchering
				# 0: "n","n",
				# 1: "n","y","1",
				# 2: "y","2","n",
				@turn.game.players[0].tokens[:sheep].should be == 4
				@turn.game.players[0].tokens[:cows].should be == 1
				@turn.game.players[0].tokens[:food].should be == 0
				@turn.game.players[1].tokens[:sheep].should be == 4
				@turn.game.players[1].tokens[:cows].should be == 0
				@turn.game.players[1].tokens[:food].should be == 18
				@turn.game.players[2].tokens[:sheep].should be == 2
				@turn.game.players[2].tokens[:cows].should be == 1
				@turn.game.players[2].tokens[:food].should be == 24
			end
		end


		it "should handle tree/boat destroying correctly" do
			InputFaker.with_fake_input(["n","n","n","n","y","1","y","2","n","n","2","0","1","0","0","1"]) do
				@turn.autumn
				# trees/boats
				# 0: "2","0"
				# 1: "1","0"
				# 2: "0","1"
				@turn.game.players[0].tokens[:boats].should be == 1
				@turn.game.players[0].tokens[:timber].should be == 2
				@turn.game.players[1].tokens[:boats].should be == 1
				@turn.game.players[1].tokens[:timber].should be == 1
				@turn.game.players[2].tokens[:boats].should be == 0
				@turn.game.players[2].tokens[:timber].should be == 1
				@turn.game.tree_track.should be == 96
			end
		end
	end

	describe "Early Winter" do

		before(:each) do
			@turn.game.players.each do |player|
				player.tokens[:hay] = 80
				player.tokens[:food] = 80
				player.barns = 5
			end
		end

		it "should have all baby livestock grow up" do
			InputFaker.with_fake_input(["n","5","1","4","2","4","1","y","y","y"]) do
				@turn.game.players[0].nursery[:sheep] = 1
				@turn.game.players[2].nursery[:cows] = 1
				@turn.early_winter
				@turn.game.players[0].tokens[:sheep].should be == 5
				@turn.game.players[0].tokens[:cows].should be == 1
				@turn.game.players[1].tokens[:sheep].should be == 4
				@turn.game.players[1].tokens[:cows].should be == 2
				# Player 3 had no babies and is unaffected here
				@turn.game.players[2].tokens[:sheep].should be == 4
				@turn.game.players[2].tokens[:cows].should be == 1
				# No more baby livestock for anyone
				@turn.game.players[0].nursery[:sheep].should be == 0
				@turn.game.players[0].nursery[:cows].should be == 0
				@turn.game.players[1].nursery[:sheep].should be == 0
				@turn.game.players[1].nursery[:cows].should be == 0
			end
		end

		it "should save the right number of livestock indoors" do
			InputFaker.with_fake_input(["n","2","0","0","1","0","1","y","y","n"]) do
				# sheep/cows into barns
				# 0: "2","0"
				# 1: "0","1"
				# 2: "0","1"
				@turn.game.players[2].barns = 0 # What if they have no barn? Woe.
				@turn.early_winter
				@turn.game.players[0].tokens[:sheep].should be == 2
				@turn.game.players[0].tokens[:cows].should be == 0
				@turn.game.players[1].tokens[:sheep].should be == 0
				@turn.game.players[1].tokens[:cows].should be == 1
				@turn.game.players[2].tokens[:sheep].should be == 0
				@turn.game.players[2].tokens[:cows].should be == 0
			end
		end

		it "should have sheep decisions affect hay and soil" do
			InputFaker.with_fake_input(["n","0","1","0","1","2","0","n","y","n"]) do
				# spend hay on sheep? "n","y","n"
				@turn.game.players[1].tokens[:hay] = 0 
				@turn.game.players[2].tokens[:hay] = 0
				@turn.early_winter
				@turn.game.players[0].tokens[:hay].should be == 74
				@turn.game.players[0].tokens[:sheep].should be == 0
				@turn.game.players[0].tokens[:cows].should be == 1
				@turn.game.players[1].tokens[:sheep].should be == 0
				@turn.game.players[1].tokens[:cows].should be == 0
				@turn.game.players[1].soil_track.should be == 103
				@turn.game.players[2].tokens[:sheep].should be == 2
				@turn.game.players[2].tokens[:cows].should be == 0
				@turn.game.players[2].soil_track.should be == 99
			end
		end

		it "should require the right amount of food to be spent per person" do
			InputFaker.with_fake_input(["n","2","0","0","1","0","1","y","y","n"]) do
				@turn.game.players[2].tokens[:food] = 0
				@turn.early_winter
				@turn.game.players[2].should be == nil
				@turn.game.players[1].tokens[:local_people].should be == 4
				@turn.game.players[0].tokens[:local_people].should be == 4
			end
		end
	end

	describe "Mid Winter" do

		before(:each) do
			@turn.game.players.each do |player|
				player.tokens[:hay] = 80
				player.tokens[:food] = 80
			end
		end

		it "should build/repair the right number of boats/barns" do
			InputFaker.with_fake_input(["1","0","2","0","2","0","0","0","1","n","Ann"]) do
				# repair_barn/build_barn/build_boat
				# 0: "1","0","2" (shouldn't have enough timber for the boats)
				# 1: "0","2","0"
				# 2: "0","0","1"
				@turn.game.players[0].name = "Ann"
				@turn.game.players[0].tokens[:timber] = 2
				@turn.game.players[1].tokens[:timber] = 12
				@turn.game.players[1].tokens[:local_people] = 12
				@turn.game.players[2].tokens[:timber] = 3
				@turn.game.players[2].tokens[:local_people] = 3
				@turn.mid_winter
				@turn.game.players[0].barns.should be == 1
				@turn.game.players[0].tokens[:boats].should be == 1
				@turn.game.players[1].barns.should be == 2
				@turn.game.players[1].tokens[:boats].should be == 1
				@turn.game.players[2].barns.should be == 0
				@turn.game.players[2].tokens[:boats].should be == 2
			end
		end

		it "should choose the right dealer" do
			InputFaker.with_fake_input(["1","0","2","0","2","0","0","0","1","n","Ben"]) do
				# repair_barn/build_barn/build_boat
				# 0: "1","0","2" (shouldn't have enough timber for the boats)
				# 1: "0","2","0"
				# 2: "0","0","1"
				@turn.game.players[0].tokens[:local_people] = 12
				@turn.mid_winter
				@turn.game.players[0].name.should be == "Ben"
			end
		end
	end
end











