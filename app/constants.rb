# frozen_string_literal: true

require "tty-prompt"
require "paint"

$prompt = TTY::Prompt.new
$rand = Random.new

CHARACTER_CREATION = {
  origins: {
    message: "As a youth, they spent their time: ",
    options: [
      "As a noble, living in the manor of a rich lord",
      "As an orphan, living in the mines in the northern region",
      "A child of a humble labourer",
      "A squire to a high ranking knight",
      "As an orphan, a pickpocket in the wealthy cities",
    ],
    effects: [
      { intelligence: 2 },
      { strength: 3, intelligence: -1 },
      { strength: 2 },
      { strength: 1, charisma: 1 },
      { agility: 3, intelligence: -1 },
    ],
  },
  hobby: {
    message: "In their free time, they loved to: ",
    options: [
      "Partake in the arts",
      "Play sports",
      "Watch the traders and merchants",
      "Study",
    ],
    effects: [
      { agility: 1 },
      { strength: 1 },
      { charisma: 1 },
      { intelligence: 1 },
    ],
  },
  journey: {
    message: "They made their way to Aldruia in pursuit of: ",
    options: [
      "Power",
      "Fame",
      "Adventure",
      "Reflection",
    ],
    effects: [
      { strength: 1, agility: -1 },
      { charisma: 1, strength: -1 },
      { agility: 1, intelligence: -1 },
      { intelligence: 1, charisma: -1 },
    ],
  },
}.freeze

ROUTES = {
  "Bridlerry" => ["Colwes"],
  "St. Thamesheath" => ["Colwes"],
  "Colwes" => ["Bridlerry", "St. Thamesheath", "Stonehod"],
  "Stonehod" => ["Colwes", "Houthend", "Peleigh", "Gernard"],
  "Peleigh" => ["Stonehod"],
  "Houthend" => ["Stonehod"],
  "Gernard" => ["Stonehod", "Hulkingford", "Lenscliffe"],
  "Hulkingford" => ["Gernard", "Tunbright"],
  "Tunbright" => ["Hulkingford", "Wellin"],
  "Wellin" => ["Tunbright", "Lenscliffe"],
  "Lenscliffe" => ["Gernard", "Wellin", "Tothet"],
  "Tothet" => ["Lenscliffe", "Surstead"],
  "Surstead" => ["Tothet"],
}.freeze
