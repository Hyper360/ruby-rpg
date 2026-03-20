# frozen_string_literal: true

require_relative "constants"
require_relative "entity"

def display_party(party, name)
  puts name
  party.each(&:display)
  puts
end

def select_target(party)
  $prompt.select(
    Paint["Who do you want to target?", :bold],
    Hash[party.map { |e| "#{e.name} HP: #{e.health}" }.zip(party.each)],
  )
end

def select_attack(entity)
  $prompt.select(
    "What attack do you want to use?",
    {
      "Regular Attack" => "Regular Attack",
      "Heavy Attack (STR: #{entity.attribute(:strength)})" => "Heavy Attack",
      "Quick Attack (SPD: #{entity.attribute(:speed)})" => "Quick Attack",
    },
  )
end

def damage_output_calculation(entity, action_option)
  action = action_option

  case action
  when "Regular Attack"
    entity.damage_output
  when "Heavy Attack"
    strength_check = entity.attribute(:strength) / 18
    if $rand.rand(0.0..1.0) < strength_check
      puts Paint["The heavy attack was successfully pulled off!!!", :green]
      entity.damage_output * ((entity.attribute(:strength) / 15) + 1)
    else
      puts Paint["The heavy attack failed!!!", :red]
      entity.damage_output * 0.5
    end
  when "Quick Attack"
    speed_check = entity.attribute(:speed) / 18
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
  dodge_check = (target.attribute(:speed) / 22.5)
  parry_check = (target.attribute(:agility) / 135)

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
  sleep(2)
end

def attack(entity, target, attack_option)
  damage = damage_output_calculation(entity, attack_option) # Calculate damage output by attacker
  damage = damage_input_calculation(target, damage) # Calculate damage input (or parry) by defender
  target.health -= damage if damage.positive?
  entity.health += damage if damage.negative? # NOTE: If true, entity recieves damage

  puts "#{target.name} has died!" if target.health <= 0
  sleep(2)
  system("clear")
end

def use_item(entity)
  puts "There are no items in your bag!"
end

def run(player_party, enemy_party)
  puts "You are about to run..."
  sleep(1)
  print(" but then you remember that you skipped leg day...")
  sleep(2)
  puts Paint["You failed to run", :red, :bold]
end

def enemy_action
  action_id = $rand.rand(0..2)
  case action_id
  when 0
    "Regular Attack"
  when 1
    "Heavy Attack"
  when 2
    "Quick Attack"
  end
end

def battle(player_party, enemy_party)
  puts Paint["You have found yourself in a battle!!!", :red]
  display_party(player_party, Paint["Player Party:", :green])
  display_party(enemy_party, Paint["Enemy Party:", :yellow])
  sleep(5)
  system("clear")

  battle_ongoing = true
  while battle_ongoing
    player_party.each do |character|
      next unless character.health.positive?

      character.display
      action = $prompt.select(
        "What do you want #{character.name} to do?",
        ["Attack", "Use Item", "Run"],
      )

      case action
      when "Attack"
        puts "#{character.name} is preparing an attack!"
        target = select_target(enemy_party)
        action = select_attack(character)
        attack(character, target, action)
      when "Use Item"
        use_item(character)
      when "Run"
        run(player_party, enemy_party)
      end
      system("clear")
    end

    enemy_party.each do |enemy|
      next unless enemy.health.positive?

      puts "#{enemy.name} is preparing an attack!"
      enemy.display

      target = player_party.sample
      action = enemy_action
      attack(enemy, target, action)
    end

    if enemy_party.select { |e| e.health.positive? }.size.negative?
      puts "You Win!"
      battle_ongoing = false
    elsif player_party.select { |p| p.health.positive? }.size.negative?
      puts "You Lose!"
      battle_ongoing = false
    else
      puts "Next Round..."
    end
    system("clear")
  end
  system("clear")
end
