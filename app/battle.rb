# frozen_string_literal: true

require_relative "constants"
require_relative "entity"

class Battle
  def generate_enemy_party(count)
    enemy_party = []
    (1..count).each do
      enemy_template = $world.random_enemy_template
      raise "Attempt to generate enemies before loading them" if enemy_template.nil?

      # Clone and reassign weapon/armor to avoid sharing references
      new_enemy = enemy_template.clone
      new_enemy.weapon = enemy_template.weapon.dup unless enemy_template.weapon.nil?
      new_enemy.armor = enemy_template.armor.dup unless enemy_template.armor.nil?
      new_enemy.health = enemy_template.health
      enemy_party << new_enemy
    end

    enemy_party
  end

  def initialize(player_party, enemy_party = nil)
    raise ArgumentError, "Player party is required" if player_party.nil? || player_party.empty?

    @player_party = player_party.is_a?(Array) ? player_party : [player_party]

    # Calculate enemy count: proportional to player size, minimum 1, capped at ENCOUNTER_ENEMY_COUNT_CAP
    enemy_count = [@player_party.size / 2, 1].max
    enemy_count = [enemy_count, ENCOUNTER_ENEMY_COUNT_CAP].min

    @enemy_party = if enemy_party.nil? || enemy_party.empty?
                     generate_enemy_party(enemy_count)
                   else
                     enemy_party
                   end

    battle
  end

  attr_reader :player_party, :enemy_party

  private

  def display_party(party, name)
    puts name
    party.each(&:display)
    puts
  end

  def select_target(party)
    targets = party.to_h { |e| ["#{e.name} HP: #{e.health}", e] }
    selected = $prompt.select(
      Paint["Who do you want to target?", :bold],
      targets.keys
    )
    targets[selected]
  end

  def select_attack(entity)
    $prompt.select(
      "What attack do you want to use?",
      {
        "Regular Attack" => "Regular Attack",
        "Heavy Attack (STR: #{entity.stats.attribute_get(:strength)})" => "Heavy Attack",
        "Quick Attack (SPD: #{entity.stats.attribute_get(:speed)})" => "Quick Attack",
      }
    )
  end

  def damage_output_calculation(entity, action_option)
    action = action_option

    case action
    when "Regular Attack"
      entity.damage_output
    when "Heavy Attack"
      strength_check = entity.stats.attribute_get(:strength) / 18
      if $rand.rand(0.0..1.0) < strength_check
        puts Paint["The heavy attack was successfully pulled off!!!", :green]
        entity.damage_output * ((entity.stats.attribute_get(:strength) / 15) + 1)
      else
        puts Paint["The heavy attack failed!!!", :red]
        entity.damage_output * 0.5
      end
    when "Quick Attack"
      speed_check = entity.stats.attribute_get(:speed) / 18
      if $rand.rand(0.0..1.0) < speed_check
        puts Paint["The quick attack was successfull!!!", :green]
        entity.damage_output
      else
        puts Paint["The quick attack failed!!!", :red]
        0
      end
    end
  end

  def damage_input_calculation(target, damage)
    dodge_check = (target.stats.attribute_get(:speed) / 22.5)
    parry_check = (target.stats.attribute_get(:agility) / 135)

    if $rand.rand(0.0..1.0) < dodge_check
      puts "But the attack was dodged!!!"
      0
    elsif $rand.rand(0.0..1.0) < parry_check
      puts "But the attack was parried!!!"
      -(damage * 0.25)
    else
      final_damage = (damage - target.defense_output).positive? ? damage - target.defense_output : 0
      final_damage = final_damage.round(1)
      puts "#{target.name} recieved #{final_damage} damage!!!"
      final_damage
    end
  end

  def attack(entity, target, attack_option)
    damage = damage_output_calculation(entity, attack_option) # Calculate damage output by attacker
    damage = damage_input_calculation(target, damage) # Calculate damage input (or parry) by defender

    if damage.positive?
      target.health -= damage
    elsif damage.negative?
      entity.health += damage
    end

    puts "#{target.name} has died!" if target.health <= 0
    system("clear")
  end

  def use_item(character)
    puts "#{character.name}: Your bag is empty!"
  end

  def run_attempt
    return unless enemy_party.any? { |e| e.health.positive? }

    puts "You are about to flee..."
    print(" but then you remember that you skipped leg day...")
    puts Paint["You failed to escape!", :red, :bold]
  end

  def check_end_condition
    if @enemy_party.all? { |e| e.health <= 0 }
      puts "You Win!"
      true
    elsif @player_party.all? { |p| p.health <= 0 }
      puts "You Lose!"
      true
    else
      puts "Next Round..."
      false
    end
  end

  def player_turn
    return unless @enemy_party.any? { |e| e.health.positive? }

    @player_party.each do |character|
      next unless character.health.positive?

      character.display
      choice = $prompt.select(
        "What do you want #{character.name} to do?",
        ["Attack", "Use Item", "Run"]
      )

      case choice
      when "Attack"
        puts "#{character.name} is preparing an attack!"
        target = select_target(@enemy_party)
        attack_action = select_attack(character)
        attack(character, target, attack_action)
      when "Use Item"
        use_item(character)
      when "Run"
        run_attempt
      end
      system("clear")
    end
  end

  def enemy_turn
    return unless @enemy_party.any? { |e| e.health.positive? }

    @enemy_party.each do |enemy|
      next unless enemy.health.positive?

      puts "#{enemy.name} is preparing an attack!"
      enemy.display

      next unless @player_party.any? { |p| p.health.positive? }

      target = @player_party.find { |p| p.health.positive? } || @player_party.sample
      action = random_enemy_action(enemy)
      attack(enemy, target, action)
    end
  end

  def random_enemy_action(_entity)
    case $rand.rand(0..2)
    when 0 then "Regular Attack"
    when 1 then "Heavy Attack"
    when 2 then "Quick Attack"
    end
  end

  def battle
    puts Paint["You have found yourself in a battle!!!", :red]
    display_party(@player_party, Paint["Player Party:", :green])
    display_party(enemy_party, Paint["Enemy Party:", :yellow])
    system("clear")

    battle_ongoing = true
    while battle_ongoing
      player_turn
      break unless enemy_party.any? { |e| e.health.positive? }

      enemy_turn
      break unless @player_party.any? { |p| p.health.positive? }

      battle_ongoing = !check_end_condition
    end
  end
end
