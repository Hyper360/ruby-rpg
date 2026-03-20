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

    # Proficiencies (out of 5)
    # Main character should have 3 points to start
    # Weapons will also be rock-paperscissors based re. battle
    @proficiencies = {
      swords: 0,
      maces: 0,
      bows: 0,
      spears: 0,
      daggers: 0,
      fists: 1,
    }
  end

  def attribute_set(symbol, value)
    if @primary_attributes.key?(symbol)
      unless value.between?(0, 45)
        raise ArgumentError, "Value for Primary Attribute #{symbol} is out of range (Should be between 0-45)"
      end

      @primary_attributes[symbol] = value

    elsif @secondary_attributes.key?(symbol)
      unless value.between?(0, 15)
        raise ArgumentError, "Value for Secondary Attribute #{symbol} is out of range (Should be between 0-15)"
      end

      @secondary_attributes[symbol] = value

    elsif @proficiencies.key?(symbol)
      unless value.between?(0, 5)
        raise ArgumentError, "Value for Profeciency #{symbol} is out of range (Should be between 0-5)"
      end

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
  end

  def generate_action_points
    @action_points += attribute(:speed) / 5
  end

  def damage_output
    # Damage output is strength + (weapon_damage * (proficiency / 5) + 1) + (domination * 0.25)
    base_damage = @primary_attributes[:strength]
    base_damage += @weapon.damage * ((@proficiencies[@weapon.type] / 5) + 1)
    base_damage += @secondary_attributes[:domination] * 0.25
    $rand.rand((base_damage * 0.95)..(base_damage * 1.05))
  end

  def defense_output
    @armor.defense + (@secondary_attributes[:domination] / 5) + (@primary_attributes[:strength] / 5)
  end
end
