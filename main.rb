# frozen_string_literal: true

require_relative "app/game"
require_relative "app/loader"

system("clear")
title = <<~TEXT
         ***** ***                  *                               ***** ***          ***** **          * ***#{'      '}
  #{'                                                                                                                            '}
      ******  * **                **                             ******  * **       ******  ****       *  ****  *#{'   '}
     **   *  *  **                **                            **   *  *  **      **   *  *  ***     *  *  ****#{'    '}
    *    *  *   **                **                           *    *  *   **     *    *  *    ***   *  **   **#{'     '}
        *  *    *   **   ****     **         **   ****             *  *    *          *  *      **  *  ***#{'          '}
       ** **   *     **    ***  * ** ****     **    ***  *        ** **   *          ** **      ** **   **#{'          '}
       ** **  *      **     ****  *** ***  *  **     ****         ** **  *           ** **      ** **   **   ***#{'    '}
       ** ****       **      **   **   ****   **      **          ** ****          **** **      *  **   **  ****  *#{' '}
       ** **  ***    **      **   **    **    **      **          ** **  ***      * *** **     *   **   ** *  ****#{'  '}
       ** **    **   **      **   **    **    **      **          ** **    **        ** *******    **   ***    **#{'   '}
       *  **    **   **      **   **    **    **      **          *  **    **        ** ******      **  **     *#{'    '}
          *     **   **      **   **    **    **      **             *     **        ** **           ** *      *#{'    '}
      ****      ***   ******* **  **    **     *********         ****      ***       ** **            ***     *#{'     '}
     *  ****    **     *****   **  *****         **** ***       *  ****    **        ** **             *******#{'      '}
    *    **     *                   ***                ***     *    **     *    **   ** **               ***#{'        '}
    *                                           *****   ***    *               ***   *  *#{'                           '}
     **                                       ********  **      **              ***    *#{'                            '}
                                             *      ****                         ******#{'                             '}
                                                                                   ***#{'                              '}
TEXT

puts Paint["Welcome to...", :gray, :italic]
title.each_line do |line|
  sleep(0.1)
  print(Paint[line, :red, :bold])
end
sleep(2)
load_components

action = $prompt.select(
  "Select an option",
  ["LOAD", "NEW GAME", "EXIT"]
)

case action
when "LOAD"
  # Does nothing!!! :D
  system("clear")
  player = File.open("assets/saves/character.marshal", "rb") do |f|
    Marshal.load(f.read)
  end
  game_loop(player)
when "NEW GAME"
  system("clear")
  player = Character.new
  player.creation
  game_loop(player)
when "EXIT"
  exit(0)
end
