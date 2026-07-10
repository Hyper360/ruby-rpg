require_relative "constants"

class Stats
  def initialize
    # M&B styled attributes
    # Primary attributes (out of 45)
    # Main character should have 3 points to start
    @primary_attributes = {
      "strength" => 5,
      "agility" => 5,
      "charisma" => 5,
      "intelligence" => 5,
    }

    # Secondary attributes (out of 15)
    # Main character should have 5 points to start
    @secondary_attributes = {
      "leadership" => 1,
      "bartering" => 1,
      "speed" => 1,
      "awareness" => 1,
      "domination" => 1,
      "elusiveness" => 1,
      "wit" => 1,
      "strategy" => 1,
    }

    # Proficiency's (out of 5)
    # to-do: Main character should have 3 points to start
    # to-do: Weapons will also be rock-paper-scissors based battle
    @proficiencies = {
      "swords" => 0,
      "maces" => 0,
      "bows" => 0,
      "spears" => 0,
      "daggers" => 0,
      "fists" => 1,
    }
  end

  def attribute_keys(points: 5)
    attributes = []
    attributes += @primary_attributes.keys if points >= STAT_COST["primary"]
    attributes += @secondary_attributes.keys if points >= STAT_COST["secondary"]
    attributes += @proficiencies.keys if points >= STAT_COST["proficiency"]
    attributes
  end

  def attribute_get(key)
    attribute(key)[:value]
  end

  def attribute_type(key)
    attribute(key)[:type]
  end

  def attribute(key)
    stat_key = key.to_s

    if @primary_attributes.key?(stat_key)
      type = "primary"
      value = @primary_attributes[stat_key]
    elsif @secondary_attributes.key?(stat_key)
      type = "secondary"
      value = @secondary_attributes[stat_key]
    elsif @proficiencies.key?(stat_key)
      type = "proficiency"
      value = @proficiencies[stat_key]
    else
      raise KeyError, "Key #{key} does not exist"
    end

    {
      type: type,
      value: value
    }
  end

  def attribute_set(key, value)
    stat_key = key.to_s

    if @primary_attributes.key?(stat_key)
      raise ArgumentError, "Value for Primary Attribute #{key} is out of range" unless value.between?(0, 45)

      @primary_attributes[stat_key] = value
    elsif @secondary_attributes.key?(stat_key)
      raise ArgumentError, "Value for Secondary Attribute #{key} is out of range" unless value.between?(0, 15)

      @secondary_attributes[stat_key] = value
    elsif @proficiencies.key?(stat_key)
      raise ArgumentError, "Value for Profeciency #{key} is out of range" unless value.between?(0, 5)

      @proficiencies[stat_key] = value
    else
      raise KeyError, "Key #{key} does not exist"
    end
  end

  def upgrade_attribute
    selection = $prompt.select(
      "Which attribute do you want to upgrade?",
      attribute_keys.map(&:to_s)
    )

    attribute(selection)
  end

  def print
    attribute_keys.each do |key|
      puts "#{key}: #{attribute_get(key)}"
    end
  end

  def verify_stats_hash(target, hash)
    return nil unless target.is_a?(Hash) && hash.is_a?(Hash)

    normalized_hash = hash.transform_keys(&:to_s)
    return nil unless target.keys.sort == normalized_hash.keys.sort

    normalized_hash.each do |key, value|
      next if value.is_a?(target[key].class)

      return nil
    end

    normalized_hash
  end

  def load_from_hash(stats_hash)
    raise "stats hash does not have primary key" unless stats_hash.key?("primary")
    raise "stats hash does not have secondary key" unless stats_hash.key?("secondary")
    raise "stats hash does not have proficiency key" unless stats_hash.key?("proficiency")

    @primary_attributes = verify_stats_hash(@primary_attributes, stats_hash["primary"])
    raise "primary attribute loading failed" if @primary_attributes.nil?

    @secondary_attributes = verify_stats_hash(@secondary_attributes, stats_hash["secondary"])
    raise "secondary attribute loading failed" if @secondary_attributes.nil?

    @proficiencies = verify_stats_hash(@proficiencies, stats_hash["proficiency"])
    raise "proficiency loading failed" if @proficiencies.nil?
  end
end
