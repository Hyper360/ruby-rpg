# frozen_string_literal: true

require_relative "constants"
require_relative "entity"
require_relative "items"
require_relative "inventory"
require "yaml"

# This class is the player class and inherits the entity attributes.
# Handles character creation and such
class Character < Entity
  attr_accessor :money
  attr_reader :inventory, :location

  def initialize
    super
    @money = 0
    @inventory = Inventory.new(30)
    @location = "Bridlerry"
  end

  def location=(value)
    routes = $world.routes
    valid_routes = routes[@location] || []
    raise ArgumentError, "Cannot travel from #{@location} to #{value}" unless valid_routes.include?(value)

    @location = value
  end

  def creation
    print("Welcome to #{Paint['Aldruia', :red]}. This is the legacy of: \n> ")
    @name = gets.chomp while @name.empty?

    CHARACTER_CREATION.each_value do |menu|
      result = $prompt.select(menu[:message], menu[:options])
      result_index = menu[:options].index(result)
      result_effects = menu[:effects][result_index]

      result_effects.values do |attribute, value|
        primary_attributes[attribute] += value
      end
      sleep(1.5)
    end

    @health = 50
    @max_health = 50
    @location = "Bridlerry"
    system("clear")
  end

  def inventory_interaction
    loop do
      action = inventory.inventory_menu

      case action
      when "view"
        inventory.list_items
      when "equip"
        item = $prompt.select(
          options: %w[Weapon Armor]
        )
        if item.is_a?(Weapon)
          @weapon = item
        elsif item.is_a?(Armor)
          @armor = item
        end
      when "drop"
        item = select_item
        inventory.remove_item(item)
      when "exit"
        break
      end
      sleep(1.5)
    end
  end

  def save_to_file
    File.open("assets/saves/character.marshal", "wb") do |f|
      f.write(Marshal.dump(self))
      f.close
    end
  end
end
