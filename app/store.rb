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
  attr_reader :weapons

  def initialize
    # Generate weapon listings and prices
    @weapon_listings = []
    generate_listings
  end

  def display_weapons
    puts "Available Weapons:"
    @weapons_listings do |wl|}
      puts "#{wl.name} - #{wl.weapon.description}"
      puts "DMG: #{wl.weapon.damage}"
      puts "PRICE: #{wl.weapon.price}"
    end
  end

  def buy_weapon(player, weapon_index)
    weapon = $prompt.select(
      "Select a weapon to buy:",
      @weapons.map { |name, weapon| {name: name, weapon: weapon} }
    )

    if player.gold >= weapon[:weapon].cost
      player.gold -= cost if player.inventory.add_item(weapon)
    end
  end

  def regenerate_listings
    @weapon_listings.clear

    $weapon_pool.sample(5) do |name, weapon|
      # For now, price will be damage * tier * 3
      # A more comprehensive pricing system will come later
      price = weapon.damage * weapon.tier
      @weapon_listings << WeaponListing.new(name, weapon, price)
    end
  end
end
