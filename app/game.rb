# frozen_string_literal: true

# Inherits from all the other game files
require_relative "constants"
require_relative "entity"
require_relative "character"
require_relative "dialogue"
require_relative "items"
require_relative "towns"
require_relative "battle"

def load_components
  load_dialogues
end

def game_loop(player)
  running = true
  while running
    case town_interaction(player)
    when "tavern"
      tavern(player)
    when "weapons"
      weapons_merchant(player)
    when "general"
      general_merchant(player)
    when "save"
      player.save_to_file
    when "leave"
      switch_town(player)
    when "exit"
      puts "Quitting Game..."
      running = false
    end
  end
end
