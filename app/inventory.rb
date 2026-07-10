require_relative "constants"
require_relative "items"

class Inventory
  attr_reader :items, :capacity

  def initialize(capacity = 30)
    @items = []
    @capacity = capacity
  end

  def empty?
    @items.empty?
  end

  def add_item(item)
    return false unless @items.size < capacity

    @items << item
    true
  end

  def remove_item(item)
    index = @items.index(item)
    return if index.nil?

    @items.delete_at(index)
  end

  def list_items
    @items.each(&:display)
  end

  def select_item_name(available_items = @items)
    $prompt.select(
      "Select an item:",
      available_items.map(&:name)
    )
  end

  def select_item(type_guard = nil)
    available_items = []

    if type_guard.nil?
      available_items = @items
    else
      return unless type_guard.is_a?(Class)
      return unless [Weapon, Armor].include?(type_guard)

      available_items = item_filter(type_guard)
    end

    return if available_items.empty?

    name = select_item_name(available_items)
    available_items.select { |item| item.name == name }.first
  end

  def item_filter(type = Item)
    return unless type.is_a?(Class)

    @items.select { |item| item.is_a?(type) }
  end
end
