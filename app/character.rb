# frozen_string_literal: true

require_relative "constants"
require_relative "entity"
require_relative "items"
require "yaml"

# This class is the player class and inherits the entity attributes.
# Handles character creation and such
class Character < Entity
  attr_reader :money, :inventory, :location

  def initialize
    super
    @money = 0
    @inventory = Array.new(30)
    @location = "Bridlerry"
  end

  def creation
    print("Welcome to #{Paint["Aldruia", :red]}. This is the legacy of: \n> ")
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

    @location = "Bridlerry"
    system("clear")
  end

  def save_to_file
    File.open("assets/saves/character.marshal", "wb") do |f|
      f.write(Marshal.dump(self))
      f.close
    end
  end

  def location=(value)
    unless ROUTES.include?(value)
      raise ArgumentError, "#{value} not a valid location."
    end
  end
end
