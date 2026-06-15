# frozen_string_literal: true

require "yaml"
require_relative "constants"
require_relative "items"
require_relative "entity"
require_relative "store"

def load_dialogues
  tavern_text = []

  File.foreach("assets/text/dialogue/tavern.txt") do |line|
    tavern_text << line.chomp
  end

  tavern_text.freeze
end

def load_armor_pool
  armor_pool = {}

  YAML.load_file("assets/items/armor.yaml").each do |data|
    name = data["name"]
    defense = data["defense"]
    weight = data["weight"]
    description = data["description"]

    armor_pool[name] = Armor.new(name, defense, weight, description)
  end

  armor_pool.freeze
end

def load_weapon_pool
  weapon_pool = {}

  YAML.load_file("assets/items/weapons.yaml").each do |data|
    name = data["name"]
    damage = data["damage"]
    type = data["type"]
    tier = data["tier"]
    description = data["description"]
    data["weight"]

    weapon_pool[name] = Weapon.new(name, damage, type, tier, description)
  end

  weapon_pool.freeze
end

def load_item_pool
  item_pool = {}

  YAML.load_file("assets/items/items.yaml").each do |data|
    name = data["name"]
    data["type"]
    data["effect"]
    data["weight"]
    description = data["description"]

    item_pool[name] = Item.new(name, description)
  end

  item_pool.freeze
end

def load_enemy_templates
  enemy_templates = {}

  YAML.load_file("assets/templates/enemies.yaml").each do |data|
    name = data["name"]
    max_health = data["max_health"]
    weapon_hash = data["weapon"]
    armor_hash = data["armor"]

    weapon_name = weapon_hash["name"]
    weapon_damage = weapon_hash["damage"]
    weapon_type = weapon_hash["type"]
    weapon_tier = weapon_hash["tier"] || 0

    armor_name = armor_hash["name"]
    armor_defense = armor_hash["defense"]
    armor_weight = armor_hash["weight"]

    enemy_templates[name] = Entity.new(name, max_health)
    enemy_templates[name].weapon = Weapon.new(weapon_name, weapon_damage, weapon_type, weapon_tier)
    enemy_templates[name].armor = Armor.new(armor_name, armor_defense, armor_weight)
  end

  enemy_templates.freeze
end

def load_weapon_stores(weapon_pool)
  weapon_stores = {}

  ROUTES.each_key do |route|
    weapon_stores[route] = WeaponsStore.new(weapon_pool)
  end

  weapon_stores.freeze
end

def load_components
  tavern_text = load_dialogues
  armor_pool = load_armor_pool
  weapon_pool = load_weapon_pool
  item_pool = load_item_pool
  enemy_templates = load_enemy_templates
  weapon_stores = load_weapon_stores(weapon_pool)

  {
    tavern_text: tavern_text,
    armor_pool: armor_pool,
    weapon_pool: weapon_pool,
    item_pool: item_pool,
    enemy_templates: enemy_templates,
    weapon_stores: weapon_stores
  }
end
