# How enemies will choose what actions to take

Enemies will only have access to that the player has access to, which would be:
- Name
- Health
- Primary attributes
- Weapons and armor

Enemies will only be able to attack!

### Enemy attack decision tree:
- Who to attack:
    - Weakest enemy if:
        - Own health is low
        - Own strength is low
        - Enemy health is critical
    - Strongest enemy if:
        - Own health is high
        - Own strength is high
        - Enemy has not been damaged
    - Otherwise, RPS:
        - Check Proficiencies brainstorm

- When to run:
    - Most allies are dead
    - Own health is low
    - Not a mob

- What attack to use:
    - Heavy if
        - Strength is high
        - Health is high
    - Quick if
        - Speed is high
        - Health is moderate
    - Normal if other conditions fail
