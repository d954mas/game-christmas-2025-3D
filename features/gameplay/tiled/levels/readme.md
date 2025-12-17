Use Tiled as level editor for game

To export from tiled i make some rules and code.

For game i use my own format. So it worked like that

Tiled -> export to lua -> run parser.lua -> .json file

Use tiled to draw tile in level. Also placed game objects with config.

It support rotated and flipped tiled.

1.You need tilesets.tmx
This is tilemap with add tilesets used in game.


Tile layer pathdfinding can be use to mark cell as blocked. This is used in pathfinding


This game Use
https://murphysdad.itch.io/christmas-village-asset-pack
