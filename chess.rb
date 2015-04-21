puts "chess.rb initiated."

Dir[File.dirname(__FILE__) + '/pieces/*.rb'].each { |file| require file }
require_relative 'game'
require_relative 'square'

Game.new()

puts "chess.rb terminated."
