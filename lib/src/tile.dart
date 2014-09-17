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

class Tile {
  int width = 0;
  int height = 0;
  int attribute = 0;
  int blitMode = 0;
  Uint8List pixel;

  Tile.fromPixel(int width, int height, Uint8List pixel, {int attribute, int ink, int paper, int bright}) {
    this.width = width;
    this.height = height;

    if (attribute != null) {
      this.attribute = attribute;
    } else {
      this.attribute = createAttribute(ink:ink, paper:paper, bright:bright);
    }

    this.pixel = new Uint8List.fromList(pixel);
  }

  Tile.fromTile(Tile tile) {
    width     = tile.width;
    height    = tile.height;
    attribute = tile.attribute;
    pixel = new Uint8List.fromList(tile.pixel);
  }
}