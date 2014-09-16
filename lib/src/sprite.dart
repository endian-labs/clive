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

class Sprite extends Tile {
  int x = 0;
  int y = 0;
  bool visible = true;

  Sprite(int width, int height, Uint8List pixel, {int attribute, int ink, int paper, int bright}) :
    super(width, height, pixel, attribute:attribute, ink:ink, paper:paper, bright:bright) {
  }

  void setPosition(x, y) {
    this.x = x;
    this.y = y;
  }
}