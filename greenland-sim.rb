$:.unshift File.expand_path('.')
require 'greenland'

@sim_game = Game.new
@sim_game.simulation
@sim_game.play