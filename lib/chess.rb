puts "chess.rb initiated."

Dir[File.dirname(__FILE__) + 'chess/pieces/*.rb'].each { |file| require file }
require_relative 'chess/game'
require_relative 'chess/square'

game = Game.new()
game.engine()

puts "chess.rb terminated."
