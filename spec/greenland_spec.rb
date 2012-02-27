$:.unshift File.expand_path('.')
require 'greenland'

describe Game do

	it "should have some number of players" do
		game = Game.new(3)
		game.should respond_to(:number_players)
	end

	it "should have the right number of players" do
		game = Game.new(3)
		game.players.count.should == 3
	end
end