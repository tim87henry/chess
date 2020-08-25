'Chess' game in Ruby.
Part of The Odin Project's curriculum.

The option to save/load a game state, is included. Enter 's' to save the game, at any point.
At the beginning you could either start a new game or load an already saved game.

Sample game board:

    a  b  c  d  e  f  g  h
  --------------------------
8 | ♖  ♘  .  ♔  ♕  ♗  ♘  ♖ | 8
7 | ♙  .  ♙  .  ♙  ♙  ♙  ♙ | 7
6 | ♗  .  .  .  .  .  .  . | 6
5 | .  ♙  .  ♙  .  .  .  . | 5
4 | .  .  .  .  ♟  .  .  . | 4
3 | .  .  ♞  ♛  .  .  .  . | 3
2 | ♟  ♟  ♟  ♟  ♝  ♟  ♟  ♟ | 2
1 | ♜  .  ♝  ♚  .  .  ♞  ♜ | 1
  --------------------------
    a  b  c  d  e  f  g  h

Player needs to enter the location from and to which a piece should be moved.
Example, 'c3' to 'a4'.

The game exits once a player is declared a winner.
