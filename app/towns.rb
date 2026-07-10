# frozen_string_literal: true

require_relative "constants"
require_relative "character"
require_relative "loader"

# Random encounter system - called when moving between towns
def random_encounter(player)
  return unless $rand.rand(0.0..1.0) < ENCOUNTER_CHANCE

  world = $world
  return if world.nil? || world.enemy_templates.nil? || world.enemy_templates.empty?

  # Validate that enemy templates are loaded
  if world.enemy_templates.nil? || world.enemy_templates.empty?
    raise "Enemy templates not loaded! Call load_components first"
  end

  Battle.new([player])
end

def tavern(player)
  tavern_text = $world.tavern_text
  puts Paint[(tavern_text.sample || ""), :italic, :gray]

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
    puts "You: ...What?"
    puts Paint["You failed to obtain a drink", :red, :bold]
  when "rest"
    player.health = player.max_health
    puts "You are fully rested"
  when "leave"
    return
  end

  tavern(player)
end

def weapons_merchant(player)
  store = $world.weapon_store_for(player.location)

  while true
    action = $prompt.select(
      "What do you want to do here?",
      {
        "Browse weapons" => "browse",
        "Buy weapon" => "buy",
        "Leave" => "leave",
      }
    )

    case action
    when "browse"
      store.display_weapons
    when "buy"
      store.buy_weapon(player)
    when "leave"
      break
    end
  end
end

def armor_merchant(player)
  store = $world.armor_store_for(player.location)

  while true
    action = $prompt.select(
      "What do you want to do here?",
      {
        "Browse armor" => "browse",
        "Buy armor" => "buy",
        "Leave" => "leave",
      }
    )

    case action
    when "browse"
      store.display_armors
    when "buy"
      store.buy_armor(player)
    when "leave"
      break
    end
  end
end

def general_merchant(_player)
  puts "Merchant: Do you want titanium rope?"
  puts "You: That sounds cool, how does it bend?"
  puts "Merchant: It doesn't"
  puts ". .."
  puts Paint["You failed to obtain the titanum rope", :red, :bold]
end

def switch_town(player)
  # Random encounter check BEFORE moving to new location
  random_encounter(player)

  routes = $world.routes

  $prompt.select(
    Paint["You are currently in #{player.location}. Where do you want to go?", :yellow, :bold],
    routes[player.location]
  )
end

def town_interaction(player)
  $prompt.select(
    "You are in #{player.location}.",
    {
      "Visit the tavern" => "tavern",
      "See what weapons are available" => "weapons",
      "See what armor is available" => "armors",
      "Check out the general merchant" => "general",
      "Interact with your character" => "character",
      "Save your progress" => "save",
      "Leave town" => "leave",
      "Quit the game" => "exit",
    }
  )
end
