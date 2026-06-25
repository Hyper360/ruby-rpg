# frozen_string_literal: true

require "fileutils"
require "yaml"

# Inherits from all the other game files
require_relative "constants"
require_relative "entity"
require_relative "character"
require_relative "loader"
require_relative "items"
require_relative "towns"
require_relative "battle"

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
      modify_save_file(player)
    when "leave"
      # Random encounter already handled in random_encounter function within switch_town
      player.location = switch_town(player)
    when "exit"
      puts "Quitting Game..."
      running = false
    end
    sleep(1)
  end
end

def save_slot_name(player)
  raw_name = player.name.to_s.strip
  name = raw_name.gsub(/[^0-9A-Za-z._-]/, "_")
  name.empty? ? "save" : name
end

def save_to_file(path, player)
  player_file = "#{path}_player.yaml"
  world_file = "#{path}_world.yaml"

  FileUtils.mkdir_p(File.dirname(player_file))
  File.write(player_file, YAML.dump(player))
  File.write(world_file, YAML.dump($world))
end

def modify_save_file(player)
  save_name = "#{save_slot_name(player)}_#{$save_num}"
  save_path = File.join(SAVE_DIRECTORY, save_name)

  save_to_file(save_path, player)
  puts "Game saved."
end

def load_from_file(path)
  player_file = "#{path}_player.yaml"
  world_file = "#{path}_world.yaml"

  raise ArgumentError, "Save file not found: #{path}" unless File.exist?(player_file) && File.exist?(world_file)

  {
    player: YAML.unsafe_load_file(player_file),
    world: YAML.unsafe_load_file(world_file)
  }
end

def load_game_menu
  save_options = Dir.glob(File.join(SAVE_DIRECTORY,
                                    "*_player.yaml")).sort.each_with_object({}) do |player_file, options|
    save_name = File.basename(player_file, "_player.yaml")
    match = save_name.match(/\A(.+)_(\d+)\z/)
    next if match.nil?

    display_name = match[1].tr("_", " ")
    options["#{display_name} ##{match[2]}"] = File.join(SAVE_DIRECTORY, save_name)
  end

  if save_options.empty?
    puts "No saves found."
    return nil
  end

  selected_save = $prompt.select("Choose a save", save_options)
  load_from_file(selected_save)
end
