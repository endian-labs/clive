//   ___ _ _
//  / __| (_)_ _____
// | (__| | \ V / -_)
//  \___|_|_|\_/\___|
//
// A Dart game engine for those ZX Spectrum inspired retro games.
//
// (C) 2014 Anders Holmberg, See LICENSE.txt.
//

part of clive;

class Sprite {
  int x = 0;
  int y = 0;
  int activeTile = 0;
  bool visible = true;
  List<Tile> tiles = new List();

  Sprite(int width, int height, Uint8List pixel, {int attribute, int ink, int paper, int bright}) {
    this.tiles.add(new Tile.fromPixel(width, height, pixel, attribute:attribute, ink:ink, paper:paper, bright:bright));
  }

  Sprite.fromTile(Tile tile) {
    this.tiles.add(new Tile.fromTile(tile));
  }

  void addTile(Tile tile) {
    this.tiles.add(new Tile.fromTile(tile));
  }

  void setPosition(x, y) {
    this.x = x;
    this.y = y;
  }

  void setActiveTile(int idx) {
    activeTile = idx;
  }
}