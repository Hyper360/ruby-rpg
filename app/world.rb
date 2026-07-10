# frozen_string_literal: true

require_relative "loader"

class World
  attr_reader :enemy_templates, :armor_pool, :weapon_pool, :item_pool, :tavern_text, :weapon_stores, :armor_stores, :routes

  def initialize
    components = load_components

    @tavern_text = components[:tavern_text]
    @enemy_templates = components[:enemy_templates]
    @armor_pool = components[:armor_pool]
    @weapon_pool = components[:weapon_pool]
    @item_pool = components[:item_pool]
    @weapon_stores = components[:weapon_stores]
    @armor_stores = components[:armor_stores]
    @routes = ROUTES
  end

  def random_enemy_template
    return if @enemy_templates.empty?

    @enemy_templates.values.sample
  end

  def weapon_store_for(location)
    @weapon_stores[location]
  end

  def armor_store_for(location)
    @armor_stores[location]
  end
end
