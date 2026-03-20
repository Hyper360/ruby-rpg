# frozen_string_literal: true

TAVERN_TEXT = []

def load_dialogues
  File.foreach("assets/text/dialogue/tavern.txt") do |line|
    TAVERN_TEXT << line.chomp
  end
end
