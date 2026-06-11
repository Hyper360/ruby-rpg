# frozen_string_literal: true

require "json"

# General Item Class
class Item
  attr_reader :name, :desc

  def initialize(name, description = "")
    self.name = name
    self.desc = description
  end

  def name=(value)
    raise ArgumentError, "#{value} is not a String." unless value.is_a?(String)

    @name = value
  end

  def desc=(value)
    raise ArgumentError, "#{value} is not a String." unless value.is_a?(String)

    @desc = value
  end

  def display
    puts "Name: #{name}"
    puts "Description: #{desc}"
  end
end

# Weapon class
class Weapon < Item
  attr_reader :damage, :type, :tier

  def initialize(name, damage, type, tier, description = "")
    super(name, description)
    self.damage = damage
    self.type = type
    self.tier = tier
  end

  def damage=(value)
    raise ArgumentError, "#{value} is not an Integer." unless value.is_a?(Integer)

    @damage = value
  end

  def type=(value)
    raise ArgumentError, "#{value} is not a Symbol." unless value.is_a?(Symbol)

    unless %i[swords maces bows spears daggers fists].include?(value)
      raise ArgumentError, "#{value} is not a valid Symbol."
    end

    @type = value
  end

  def tier=(value)
    raise ArgumentError, "#{value} is not an Integer." unless value.is_a?(Integer)

    raise ArgumentError, "#{value} is not a valid Integer." unless (1..5).include?(value)

    @tier = value
  end
end

# Armor class
class Armor < Item
  attr_reader :defense, :weight

  def initialize(name, defense, weight, description = "")
    super(name, description)
    @defense = defense
    @weight = weight
  end

  def defense=(value)
    raise ArgumentError, "#{value} is not an Integer." unless value.is_a?(Integer)

    @defense = value
  end
end
