$:.unshift File.expand_path('.')
require 'greenland'
require 'strategies'

game = GameFactory.game_from_console
GameFactory.name_players_from_console(game)

game.play
