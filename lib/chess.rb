puts "chess.rb initiated."

Dir[File.dirname(__FILE__) + 'chess/pieces/*.rb'].each { |file| require file }
require_relative 'chess/game'
require_relative 'chess/square'

Game.new()

puts "chess.rb terminated."
