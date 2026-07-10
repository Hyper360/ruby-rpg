# frozen_string_literal: true

require "fileutils"
require "yaml"

# Inherits from all the other game files
require_relative "constants"
require_relative "world"
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
    when "armors"
      armor_merchant(player)
    when "general"
      general_merchant(player)
    when "character"
      player.character_menu
    when "save"
      modify_save_file(player)
    when "load"
      puts "Load during game UNIMPLEMENTED"
    when "leave"
      player.location = switch_town(player)
    when "exit"
      puts "Quitting Game..."
      running = false
    end
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

def save_slot_options(player)
  slot_name = save_slot_name(player)
  existing_slots = Dir.glob(File.join(SAVE_DIRECTORY, "#{slot_name}_*_player.yaml")).filter_map do |player_file|
    save_name = File.basename(player_file, "_player.yaml")
    match = save_name.match(/\A#{Regexp.escape(slot_name)}_(\d+)\z/)

    match[1].to_i unless match.nil?
  end.sort

  display_name = slot_name.tr("_", " ")
  next_slot = existing_slots.empty? ? 0 : existing_slots.last + 1
  existing_slots.to_h do |slot|
    ["Overwrite #{display_name} ##{slot}", slot]
  end.merge("New save ##{next_slot}" => next_slot)
end

def save_game_menu(player)
  selected_slot = $prompt.select("Choose a save slot", save_slot_options(player))

  File.join(SAVE_DIRECTORY, "#{save_slot_name(player)}_#{selected_slot}")
end

def modify_save_file(player)
  save_path = save_game_menu(player)

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
