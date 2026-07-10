require_relative "items"
require_relative "constants"

class WeaponListing
  attr_reader :name, :weapon, :price

  def initialize(name, weapon, price)
    @name = name
    @weapon = weapon
    @price = price
  end
end

class ArmorListing
  attr_reader :name, :armor, :price

  def initialize(name, armor, price)
    @name = name
    @armor = armor
    @price = price
  end
end

class WeaponsStore
  attr_reader :weapon_listings

  @@weapon_pool = nil

  def initialize(weapon_pool)
    @@weapon_pool = weapon_pool if @@weapon_pool.nil?
    @weapon_listings = []
    regenerate_listings
  end

  def display_weapons
    puts "Available Weapons:"
    @weapon_listings.each do |listing|
      puts "#{listing.name} - #{listing.weapon.desc}"
      puts "DMG: #{listing.weapon.damage}"
      puts "PRICE: #{listing.price}"
      puts
    end
  end

  def buy_weapon(player)
    return false if @weapon_listings.empty?

    selected_name = $prompt.select(
      "Select a weapon to buy:",
      @weapon_listings.map(&:name)
    )

    selected_listing = @weapon_listings.find { |listing| listing.name == selected_name }
    return false if selected_listing.nil?

    if player.money < selected_listing.price
      puts "You don't have enough cash"
      return false
    end

    return false unless player.inventory.add_item(selected_listing.weapon)

    player.money -= selected_listing.price
    puts "'DEAL', #{selected_name} bought for #{selected_listing.price}"
    @weapon_listings.delete(selected_listing)
  end

  def regenerate_listings(_weapon_pool = @@weapon_pool)
    @weapon_listings.clear
    pool = @@weapon_pool
    return if pool.nil? || pool.empty?

    pool.to_a.sample(5).each do |name, weapon|
      # For now, price will be damage * tier * 3
      # A more comprehensive pricing system will come later
      effective_tier = [weapon.tier, 1].max
      price = weapon.damage * effective_tier * 3
      @weapon_listings << WeaponListing.new(name, weapon, price)
    end
  end
end

class ArmorStore
  attr_reader :armor_listings

  @@armor_pool = nil

  def initialize(armor_pool)
    @@armor_pool = armor_pool if @@armor_pool.nil?
    @armor_listings = []
    regenerate_listings
  end

  def display_armors
    puts "Available Armor:"
    @armor_listings.each do |listing|
      puts "#{listing.name} - #{listing.armor.desc}"
      puts "DEF: #{listing.armor.defense}"
      puts "WEIGHT: #{listing.armor.weight}"
      puts "PRICE: #{listing.price}"
      puts
    end
  end

  def buy_armor(player)
    return false if @armor_listings.empty?

    selected_name = $prompt.select(
      "Select an armor to buy:",
      @armor_listings.map(&:name)
    )

    selected_listing = @armor_listings.find { |listing| listing.name == selected_name }
    return false if selected_listing.nil?

    if player.money < selected_listing.price
      puts "You don't have enough cash"
      return false
    end

    return false unless player.inventory.add_item(selected_listing.armor)

    player.money -= selected_listing.price
    puts "'DEAL', #{selected_name} bought for #{selected_listing.price}"
    @armor_listings.delete(selected_listing)
  end

  def regenerate_listings(_armor_pool = @@armor_pool)
    @armor_listings.clear
    pool = @@armor_pool
    return if pool.nil? || pool.empty?

    pool.to_a.sample(5).each do |name, armor|
      price = (armor.defense * armor.weight * 3).round
      @armor_listings << ArmorListing.new(name, armor, price)
    end
  end
end
