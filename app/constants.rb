# frozen_string_literal: true

require "tty-prompt"
require "paint"

# Global objects
$prompt = TTY::Prompt.new
$rand = Random.new
$world = nil

# Constants
ENCOUNTER_CHANCE = 1.0
ENCOUNTER_ENEMY_COUNT_CAP = 3
PROFICIENCY_BONUS = {
  0 => 0.5,
  1 => 0.8,
  2 => 1.0,
  3 => 1.2,
  4 => 1.5,
  5 => 2.0
}.freeze

CHARACTER_CREATION = {
  origins: {
    message: "As a youth, they spent their time: ",
    options: [
      "As a noble, living in the manor of a rich lord",
      "As an orphan, living in the mines in the northern region",
      "A child of a humble labourer",
      "A squire to a high ranking knight",
      "As an orphan, a pickpocket in the wealthy cities"
    ],
    effects: [
      { intelligence: 2 },
      { strength: 3, intelligence: -1 },
      { strength: 2 },
      { strength: 1, charisma: 1 },
      { agility: 3, intelligence: -1 }
    ],
  },
  hobby: {
    message: "In their free time, they loved to: ",
    options: [
      "Partake in the arts",
      "Play sports",
      "Watch the traders and merchants",
      "Study"
    ],
    effects: [
      { agility: 1 },
      { strength: 1 },
      { charisma: 1 },
      { intelligence: 1 }
    ],
  },
  journey: {
    message: "They made their way to Aldruia in pursuit of: ",
    options: %w[
      Power
      Fame
      Adventure
      Reflection
    ],
    effects: [
      { strength: 1, agility: -1 },
      { charisma: 1, strength: -1 },
      { agility: 1, intelligence: -1 },
      { intelligence: 1, charisma: -1 }
    ],
  },
}.freeze

ROUTES = {
  "Bridlerry" => ["Colwes"],
  "St. Thamesheath" => ["Colwes"],
  "Colwes" => ["Bridlerry", "St. Thamesheath", "Stonehod"],
  "Stonehod" => %w[Colwes Houthend Peleigh Gernard],
  "Peleigh" => ["Stonehod"],
  "Houthend" => ["Stonehod"],
  "Gernard" => %w[Stonehod Hulkingford Lenscliffe],
  "Hulkingford" => %w[Gernard Tunbright],
  "Tunbright" => %w[Hulkingford Wellin],
  "Wellin" => %w[Tunbright Lenscliffe],
  "Lenscliffe" => %w[Gernard Wellin Tothet],
  "Tothet" => %w[Lenscliffe Surstead],
  "Surstead" => ["Tothet"],
}.freeze
