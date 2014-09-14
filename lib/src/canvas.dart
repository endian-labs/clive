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

class Canvas {

  static const int COLOR_BLACK          = 0;
  static const int COLOR_BLUE           = 1;
  static const int COLOR_RED            = 2;
  static const int COLOR_MAGENTA        = 3;
  static const int COLOR_GREEN          = 4;
  static const int COLOR_CYAN           = 5;
  static const int COLOR_YELLOW         = 6;
  static const int COLOR_WHITE          = 7;
  static const int COLOR_BLACK_BRIGHT   = 8;
  static const int COLOR_BLUE_BRIGHT    = 9;
  static const int COLOR_RED_BRIGHT     = 10;
  static const int COLOR_MAGENTA_BRIGHT = 11;
  static const int COLOR_GREEN_BRIGHT   = 12;
  static const int COLOR_CYAN_BRIGHT    = 13;
  static const int COLOR_YELLOW_BRIGHT  = 14;
  static const int COLOR_WHITE_BRIGHT   = 15;
  static const int COLOR_TRANSPARENT    = 16;

  Map<int, Map<String, int>> _colorMap = {
    COLOR_BLACK         : { 'r':0x00, 'g':0x00, 'b':0x00 },
    COLOR_BLUE          : { 'r':0x00, 'g':0x00, 'b':0xcd },
    COLOR_RED           : { 'r':0xcd, 'g':0x00, 'b':0x00 },
    COLOR_MAGENTA       : { 'r':0xcd, 'g':0x00, 'b':0xcd },
    COLOR_GREEN         : { 'r':0x00, 'g':0xcd, 'b':0x00 },
    COLOR_CYAN          : { 'r':0x00, 'g':0xcd, 'b':0xcd },
    COLOR_YELLOW        : { 'r':0xcd, 'g':0xcd, 'b':0x00 },
    COLOR_WHITE         : { 'r':0xcd, 'g':0xcd, 'b':0xcd },
    COLOR_BLACK_BRIGHT  : { 'r':0x00, 'g':0x00, 'b':0x00 },
    COLOR_BLUE_BRIGHT   : { 'r':0x00, 'g':0x00, 'b':0xff },
    COLOR_RED_BRIGHT    : { 'r':0xff, 'g':0x00, 'b':0x00 },
    COLOR_MAGENTA_BRIGHT: { 'r':0xff, 'g':0x00, 'b':0xff },
    COLOR_GREEN_BRIGHT  : { 'r':0x00, 'g':0xff, 'b':0x00 },
    COLOR_CYAN_BRIGHT   : { 'r':0x00, 'g':0xff, 'b':0xff },
    COLOR_YELLOW_BRIGHT : { 'r':0xff, 'g':0xff, 'b':0x00 },
    COLOR_WHITE_BRIGHT  : { 'r':0xff, 'g':0xff, 'b':0xff },
    COLOR_TRANSPARENT   : { 'r':0xff, 'g':0xff, 'b':0xff }
  };

  static const int PIXEL_WIDTH = 256;
  static const int PIXEL_HEIGHT = 192;
  static const int COLUMNS = 32;
  static const int ROWS = 24;

  Uint8List _pixelBuffer = new Uint8List(PIXEL_WIDTH * PIXEL_HEIGHT);
  Uint8List _attributeBuffer = new Uint8List(COLUMNS * ROWS);

  Uint8List _pixelBufferCopy = new Uint8List(PIXEL_WIDTH * PIXEL_HEIGHT);
  Uint8List _attributeBufferCopy = new Uint8List(COLUMNS * ROWS);

  bool _dirty = false;

  CanvasElement _canvas;
  CanvasRenderingContext2D _context;
  ImageData _imageData;

  int _mult = 1;

  Canvas(canvas_id) {

    _canvas    = document.querySelector(canvas_id);
    _context   = _canvas.getContext('2d');
    _imageData = _context.createImageData(_canvas.width, _canvas.height);

    _mult = min(_canvas.width~/PIXEL_WIDTH, _canvas.height~/PIXEL_HEIGHT);

    _pixelBufferCopy.setAll(0, _pixelBuffer);
    _attributeBufferCopy.setAll(0, _attributeBuffer);
  }

  void snapshot() {
    _pixelBufferCopy.setAll(0, _pixelBuffer);
    _attributeBufferCopy.setAll(0, _attributeBuffer);
  }

  void plotPixel(int x, int y, int pixel) {
    if (x < PIXEL_WIDTH && y < PIXEL_HEIGHT) {
      var idx = x + y * PIXEL_WIDTH;
      _pixelBuffer[idx] = pixel;
    }
  }

  int getAttributeByte({int ink, int paper, bool bright}) {
    var attributeByte = 0;

    attributeByte |= ink != null ? (ink & 0x07) : 0;
    attributeByte |= paper != null ? ((paper & 0x07) << 3) : 0;
    attributeByte |= bright == null || !bright ? 0 : 0x40;

    return attributeByte;
  }

  void setAttribute(int column, int row, {int byte, int ink, int paper, bool bright}) {
    if (column <= 31 && row <= 23) {
      var attributeByte = 0;

      if (byte != null) {
        attributeByte = byte;
      } else {

        attributeByte = getAttributeByte(ink:ink, paper:paper, bright:bright);
      }

      _attributeBuffer[column + row * COLUMNS] = attributeByte;
    }
  }

  void fillAttribute(int col1, int row1, int col2, int row2, {int byte, int ink, int paper, bool bright}) {
    for (var row=row1; row<=row2; row++) {
      for (var col=col1; col<=col2; col++) {
        setAttribute(col, row, byte:byte, ink:ink, paper:paper, bright:bright);
      }
    }
  }

  void preUpdate() {
    _pixelBuffer.setAll(0, _pixelBufferCopy);
    _attributeBuffer.setAll(0, _attributeBufferCopy);
  }

  void update() {
    if (_dirty) {
      _pixelBufferCopy.setAll(0, _pixelBuffer);
      _attributeBufferCopy.setAll(0, _attributeBuffer);
      _dirty = false;
    }

    for (var idx=0; idx<(PIXEL_WIDTH*PIXEL_HEIGHT); idx++) {

      var attributeIndex = ((idx >> 3) & 0x1f) +((idx >> 6) & 0x3e0);
      var attributeByte  = _attributeBuffer[attributeIndex];
      var color;
      if (_pixelBuffer[idx] == 1) {
        color = _colorMap[attributeByte & 0x07];
      } else {
        color = _colorMap[(attributeByte >> 3) & 0x07];
      }

      var x1 = idx % 256;
      var y1 = idx ~/ 256;

      for (var y2=0; y2<_mult; y2++) {
        for (var x2=0; x2<_mult; x2++) {

          var idx2 = (x1*_mult + y1*512*_mult + x2*512 + y2) * 4;

          _imageData.data[idx2 + 0] = color['r'];
          _imageData.data[idx2 + 1] = color['g'];
          _imageData.data[idx2 + 2] = color['b'];
          _imageData.data[idx2 + 3] = 0xff;
        }
      }
    }

    _context.putImageData(_imageData, 0, 0);
  }
}
