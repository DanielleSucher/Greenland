$:.unshift File.expand_path('.')
require 'greenland'

describe Game do

	describe "New Game" do
		before(:each) do
			@game = Game.new(3)
		end

		it "should have some number of players" do
			@game.should respond_to(:number_players)
		end

		it "should have the right number of players" do
			@game.players.count.should == 3
		end

		it "should have a tree track starting at 99" do
			@game.tree_track.should == 99
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
		# Game methods to test: 
		# play
		# update_game_variables
		# name_players
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
		end
	end
end

describe Turn do

	describe "New Turn" do

		before(:each) do 
			@game = Game.new(3)
			@turn = Turn.new(@game)
		end

		it "should default to the game not being over yet" do
			@turn.game.game_over.should == false
		end

		it "should become game_over==true when the succession card is revealed" do
			@turn.game.year_deck.cards.delete( { :succession => true} )
			@turn.game.year_deck.cards.unshift( { :succession => true} )
			@turn.play
			@turn.game.game_over.should == true
		end

		it "should access the game's instance variables" do
			@turn.game.players.should == @game.players
		end
	end
end