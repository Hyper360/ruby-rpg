# frozen_string_literal: true

require_relative "constants"
require_relative "items"

class Entity
  attr_reader :name, :weapon, :armor, :max_health
  attr_accessor :health

  def initialize(name = "", health = 0)
    # Default values, can be changed in character creation
    @name = name
    @health = health
    @max_health = health
    @action_points = 0
    @weapon = Weapon.new("fists", 2, :fists)
    @armor = Armor.new("plain clothes", 2, 0.5)

    # M&B styled attributes
    # Primary attributes (out of 45)
    # Main character should have 3 points to start
    @primary_attributes = {
      strength: 5,
      agility: 5,
      charisma: 5,
      intelligence: 5,
    }

    # Secondary attributes (out of 15)
    # Main character should have 5 points to start

    @secondary_attributes = {
      leadership: 1,
      bartering: 1,
      speed: 1,
      awareness: 1,
      domination: 1,
      elusiveness: 1,
      wit: 1,
      strategy: 1,
    }

    # Proficiency's (out of 5)
    # to-do: Main character should have 3 points to start
    # to-do: Weapons will also be rock-paper-scissors based battle
    @proficiencies = {
      swords: 0,
      maces: 0,
      bows: 0,
      spears: 0,
      daggers: 0,
      fists: 1,
    }
  end

  def weapon=(new_weapon)
    raise ArgumentError, "Argument nust be of type Weapon" unless new_weapon.is_a?(Weapon)

    @weapon = new_weapon
  end

  def armor=(new_armor)
    raise ArgumentError, "Argument nust be of type Armor" unless new_armor.is_a?(Armor)

    @armor = new_armor
  end

  def attribute_set(symbol, value)
    if @primary_attributes.key?(symbol)
      raise ArgumentError, "Value for Primary Attribute #{symbol} is out of range" unless value.between?(0, 45)

      @primary_attributes[symbol] = value

    elsif @secondary_attributes.key?(symbol)
      raise ArgumentError, "Value for Secondary Attribute #{symbol} is out of range" unless value.between?(0, 15)

      @secondary_attributes[symbol] = value

    elsif @proficiencies.key?(symbol)
      raise ArgumentError, "Value for Profeciency #{symbol} is out of range" unless value.between?(0, 5)

      @proficiencies[symbol] = value

    else
      raise KeyError, "Key #{symbol} does not exist"
    end
  end

  def attribute(symbol)
    if @primary_attributes.key?(symbol)
      @primary_attributes[symbol]
    elsif @secondary_attributes.key?(symbol)
      @secondary_attributes[symbol]
    elsif @proficiencies.key?(symbol)
      @proficiencies[symbol]
    else
      raise KeyError, "Key #{symbol} does not exist"
    end
  end

  def display
    puts "#{Paint[@name, :bold]} HP: #{@health}"
    @primary_attributes.each_pair do |attribute, value|
      puts "\t#{Paint[attribute.upcase, :bold]}: #{Paint[value, :blue]}"
    end
    proficiency_descriptor = case (@proficiencies[@weapon.type])
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
    @action_points += attribute(:speed) / 5
  end

  def damage_output
    base_damage = @primary_attributes[:strength] + (@secondary_attributes[:domination] / 4)
    base_damage *= PROFICIENCY_BONUS[@proficiencies[@weapon.type]]
    $rand.rand((base_damage * 0.95)..(base_damage * 1.05))
  end

  def defense_output
    @armor.defense + (@secondary_attributes[:domination] / 5) + (@primary_attributes[:strength] / 5)
  end
end
