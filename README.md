# Ruby RPG
## What is this project?
---
An text RPG game made in Ruby, for the purposes of building my experience with the language.

### To run this project
1. run `bundle install`
2. run `bundle exec ruby main.rb`
3. Enjoy!

## Plans for Upcoming Features
### v1
#### v1.0.0
- [x] Make the player's `money` usable in shops and current economy flows.
    - [x] Weapons
    - [x] Armor
- [x] Load and use enemy primary attributes, secondary attributes, and proficiencies from YAML.
- [x] Turn the placeholder merchant screens into real shops.
    - [x] Weapon shop
    - [x] Armor shop
- [x] Add real inventory management: add, remove.
- [x] Add game saves
    - [x] Save player state
    - [x] Save world state
    - [x] Load player state
    - [x] Load world state
- [x] Give the player starting proficiency points and a way to allocate them.

#### v1.3.0
- [ ] Combat balancing fix/rework
- [ ] Enemies drop money (maybe items?)
- [ ] Add distinct flavor for towns

#### v1.5.0
- [ ] Apply origin, hobby, and journey stat modifiers during character creation.
- [ ] Hook up action points so they actually affect turn order or combat flow.
- [ ] Use weapon and armor metadata such as tier and weight.
- [ ] Allow equipping and unequipping weapons and armor.
- [ ] Finish the run / flee action so it actually exits combat.
- [ ] Add battle rewards and loot drops after victory.
- [ ] Inventory management v2, inspect and stack items

### v2 (speculative)
- [ ] Implement consumable item effects from `assets/items/items.yaml`.
    - [ ] Healing and max-HP items
    - [ ] Temporary stat buffs and debuffs
    - [ ] Action point boosts
    - [ ] Status cures and utility effects
    - [ ] Quest-item triggers and progression flags
- [ ] Implement item quantity limits and stack caps.
- [ ] Implement the proficiency rock-paper-scissors combat system.
- [ ] Make proficiencies affect hit chances, not just damage.
- [ ] Replace random enemy attack selection with the intended enemy AI decision tree.
- [ ] Add enemy target-choice logic (weakest, strongest, or strategic targets).
- [ ] Allow using items during battle.
- [ ] Add buy / sell / trade flows for weapons, armor, and items.

### v3 (speculative)
- [ ] Add party members + party management
- [ ] Add currency handling for gold, silver, and platinum coins.
- [ ] Add quest-item progression for map fragments, keys, and similar items.
- [ ] Add enemy-specific abilities or attack patterns.
- [ ] Expand tavern interactions beyond flavor text and full rest.
- [ ] Add town stability / location-based encounter variance.
- [ ] Add more exploration events between towns.
- [ ] Add a custom settings menu / configuration system (encounter rate, text speed, battle speed, etc.).
