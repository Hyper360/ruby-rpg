# frozen_string_literal: true

require_relative "app/world"
require_relative "app/game"

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

$world = World.new

action = $prompt.select(
  "Select an option",
  ["LOAD", "NEW GAME", "EXIT"]
)

case action
when "LOAD"
  system("clear")
  loaded_save = load_game_menu

  if loaded_save
    $world = loaded_save[:world]
    game_loop(loaded_save[:player])
  end
when "NEW GAME"
  system("clear")
  player = Character.new
  player.creation
  game_loop(player)
when "EXIT"
  exit(0)
end
