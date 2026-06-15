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

class WeaponsStore
  attr_reader :weapon_pool, :weapon_listings

  def initialize
    @weapon_listings = []
    regenerate_listings
  end

  def display_weapons
    puts "Available Weapons:"
    @weapon_listings.each do |listing|
      puts "#{listing.name} - #{listing.weapon.desc}"
      puts "DMG: #{listing.weapon.damage}"
      puts "PRICE: #{listing.price}"
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
    return false unless player.money >= selected_listing.price
    return false unless player.inventory.add_item(selected_listing.weapon)

    player.money -= selected_listing.price
    @weapon_listings.remove(selected_listing)
  end

  def regenerate_listings(_weapon_pool = @weapon_pool)
    @weapon_listings.clear
    pool = $world.weapon_pool
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
