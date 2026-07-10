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
    @money = 10_000
    @inventory = Inventory.new(30)
    @location = "Bridlerry"
    @upgrade_points = 15
  end

  def location=(value)
    routes = $world.routes
    valid_routes = routes[@location] || []
    raise ArgumentError, "Cannot travel from #{@location} to #{value}" unless valid_routes.include?(value)

    @location = value
  end

  def character_menu
    while true
      selection = $prompt.select(
        "Choose an option",
        {
          "Player Inventory" => "inventory",
          "Upgrade Player Stats" => "stats",
          "View Player Stats" => "list",
          "Exit" => "exit"
        }
      )

      case selection
      when "inventory"
        inventory_interaction
      when "stats"
        stats_menu
      when "list"
        stats.print
      when "exit"
        break
      end
    end
  end

  def creation
    print("Welcome to #{Paint['Aldruia', :red]}. This is the legacy of: \n> ")
    @name = gets.chomp while @name.empty?

    CHARACTER_CREATION.each_value do |menu|
      result = $prompt.select(menu[:message], menu[:options])
      result_index = menu[:options].index(result)
      result_effects = menu[:effects][result_index]

      result_effects.each do |attribute, value|
        stats.attribute_set(attribute, stats.attribute_get(attribute) + value)
      end
    end

    @health = 50
    @max_health = 50
    @location = "Bridlerry"
    system("clear")
  end

  def allocate_upgrade_points
    while upgrade_points > 0
      action = $prompt.select(
        "What do you want to upgrade?",
        {
          "Primary attributes" => "primary",
          "Secondary attributes" => "secondary",
          "Proficiency points" => "proficiency",
        }
      )

      case action
      when "primary"
      when "secondary"
      when "proficiency"
      end
    end
  end

  def inventory_interaction
    if inventory.empty?
      puts "Nothing to do with your inventory... it is empty"
      return
    end
    loop do
      action = $prompt.select(
        "What do you want to do with your inventory?",
        {
          "View items" => "view",
          "Equip item" => "equip",
          "Drop item" => "drop",
          "Exit inventory" => "exit"
        }
      )

      case action
      when "view"
        inventory.list_items
      when "equip"
        item = @inventory.select_item
        if item.nil?
          puts Paint["No available items", :red, :bold]
          next
        elsif item.is_a?(Weapon)
          @weapon = item
        elsif item.is_a?(Armor)
          @armor = item
        else
          puts "#{item.name} cannot be equipped"
          return
        end
        puts "#{item.name} is equipped"

      when "drop"
        item = inventory.select_item
        inventory.remove_item(item)
      when "exit"
        break
      end
    end
  end

  def stats_menu
    # For now, 5 upgrade points needed for proficiency growth
    # 1 for secondary attributes
    # 2 for primary attributes
    while @upgrade_points.positive?
      puts "You have #{@upgrade_points} upgrade points"
      selection = $prompt.select(
        "Which stat do you want to upgrade?",
        stats.attribute_keys(points: @upgrade_points).map(&:to_s) + ["exit"]
      ).to_sym
      return if selection == :exit

      selected_stat = stats.attribute(selection)

      stats.attribute_set(selection, selected_stat[:value] + 1) if @upgrade_points >= STAT_COST[selected_stat[:type]]

      @upgrade_points -= STAT_COST[selected_stat[:type]]

      puts Paint["#{selection.to_s.capitalize} has been upgraded to #{stats.attribute_get(selection)}", :green]
    end
  end
end
