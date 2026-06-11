# frozen_string_literal: true

require_relative "constants"
require_relative "character"
require_relative "loader"

# Random encounter system - called when moving between towns
def random_encounter(player)
  return unless $rand.rand(0.0..1.0) < ENCOUNTER_CHANCE

  return if $enemy_templates.nil? || $enemy_templates.empty?

  # Validate that enemy templates are loaded
  raise "Enemy templates not loaded! Call load_components first" if $enemy_templates.nil? || $enemy_templates.empty?

  Battle.new([player])
end

def tavern(player)
  puts Paint[$tavern_text.sample, :italic, :gray]
  sleep(0.5)

  action = $prompt.select(
    "What do you want to do here?",
    {
      "Ask for a drink." => "drink",
      "Request a room for the night" => "rest",
      "Leave" => "leave",
    }
  )

  case action
  when "drink"
    puts Paint["Bartender: This is an alcohol free zone sir", :italic]
    sleep(3)
    puts "You: ...What?"
    sleep(2)
    puts Paint["You failed to obtain a drink", :red, :bold]
    sleep(3)
  when "rest"
    player.health = player.max_health
    puts "You are fully rested"
  when "leave"
    return
  end

  tavern(player)
end

def weapons_merchant(player)
  puts "Merchant: We do not have weapons to sell. Leave."
  sleep(2)
end

def general_merchant(player)
  puts "Merchant: Do you want titanium rope?"
  sleep(1)
  puts "You: That sounds cool, how does it bend?"
  sleep(1)
  puts "Merchant: It doesn't"
  sleep(2)
  puts ". .."
  sleep(2)
  puts Paint["You failed to obtain the titanum rope", :red, :bold]
end

def switch_town(player)
  # Random encounter check BEFORE moving to new location
  random_encounter(player)

  $prompt.select(
    Paint["You are currently in #{player.location}. Where do you want to go?", :yellow, :bold],
    ROUTES[player.location]
  )
end

def town_interaction(player)
  action = $prompt.select(
    "You are in #{player.location}.",
    {
      "Visit the tavern" => "tavern",
      "See what weapons are available" => "weapons",
      "Check out the general merchant" => "general",
      "Save your progress" => "save",
      "Leave town" => "leave",
      "Quit the game" => "exit",
    }
  )
end
