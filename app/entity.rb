# frozen_string_literal: true

require_relative "constants"
require_relative "items"
require_relative "stats"

class Entity
  attr_reader :name, :weapon, :armor, :max_health, :stats
  attr_accessor :health

  def initialize(name = "", health = 0, stats = Stats.new)
    # Default values, can be changed in character creation
    @name = name
    @health = health
    @max_health = health
    @action_points = 0
    @weapon = Weapon.new("fists", 2, :fists)
    @armor = Armor.new("plain clothes", 2, 0.5)
    @stats = stats
  end

  def weapon=(new_weapon)
    raise ArgumentError, "Argument nust be of type Weapon" unless new_weapon.is_a?(Weapon)

    @weapon = new_weapon
  end

  def armor=(new_armor)
    raise ArgumentError, "Argument nust be of type Armor" unless new_armor.is_a?(Armor)

    @armor = new_armor
  end

  def display
    puts "#{Paint[@name, :bold]} HP: #{@health}"
    stats.attribute_keys.each do |attribute|
      next unless stats.attribute_type(attribute) == "primary"

      puts "\t#{Paint[attribute.to_s.upcase, :bold]}: #{Paint[stats.attribute_get(attribute), :blue]}"
    end

    proficiency_descriptor = case stats.attribute_get(@weapon.type)
                             when 0
                               "incompetent"
                             when 1
                               "in-experienced"
                             when 2
                               "average"
                             when 3
                               "trained"
                             when 4
                               "experienced"
                             when 5
                               "highly-experienced"
                             end
    puts "#{@name} is #{proficiency_descriptor} with their #{@weapon.type}"
  end

  def generate_action_points
    @action_points += stats.attribute_get(:speed) / 5
  end

  def damage_output
    base_damage = weapon.damage + stats.attribute_get(:strength) + (stats.attribute_get(:domination) / 4)
    base_damage *= PROFICIENCY_BONUS[stats.attribute_get(@weapon.type)]
    $rand.rand((base_damage * 0.95)..(base_damage * 1.05))
  end

  def defense_output
    @armor.defense + (stats.attribute_get(:domination) / 5) + (stats.attribute_get(:strength) / 5)
  end
end
