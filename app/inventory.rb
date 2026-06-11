require_relative "constants"
require_relative "items"

class Inventory
  attr_reader :items, :capacity

  def initialize(capacity = 30)
    @items = []
    @capacity = capacity
  end

  def add_item(item)
    return false unless @items.size < capacity

    @items << item
    true
  end

  def remove_item(item)
    @items.delete(item)
  end

  def list_items
    @items.each { |item| item.display }
  end

  def select_item(available_items = @items)
    $prompt.select(
      "Select an item:",
      available_items.map(&:name)
    )
  end

  def item_filter(type = Item)
    return unless type.is_a?(Class)

    @items.select { |item| item.is_a?(type) }
  end

  def inventory_menu
    $prompt.select(
      "What do you want to do with your inventory?",
      {
        "View items" => "view",
        "Equip item" => "equip",
        "Drop item" => "drop",
        "Exit inventory" => "exit"
      }
    )
  end

  def equip_item(type)
    return unless type.is_a?(Class)
    return unless [Weapon, Armor].includes?(type)

    available_items = item_filter(type)
    return if available_items.empty?

    selected_item_name = select_item(available_items)
  end
end
