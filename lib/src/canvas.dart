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
  
  Canvas(canvas_id) {

    _canvas    = document.querySelector(canvas_id);
    _context   = _canvas.getContext('2d'); 
    _imageData = _context.createImageData(_canvas.width, _canvas.height);
        
    _pixelBufferCopy.setAll(0, _pixelBuffer);
    _attributeBufferCopy.setAll(0, _attributeBuffer);

  }
  
  preUpdate() {
    _pixelBuffer.setAll(0, _pixelBufferCopy);
    _attributeBuffer.setAll(0, _attributeBufferCopy);
  }
  
  update() {
    if (_dirty) {
      _pixelBufferCopy.setAll(0, _pixelBuffer);
      _attributeBufferCopy.setAll(0, _attributeBuffer);
      _dirty = false;
    }
        
    for (var idx=0; idx<(PIXEL_WIDTH * PIXEL_HEIGHT); idx++) {
      
      var attributeIndex = ((idx >> 3) & 0x1f) +( (idx >> 6) & 0x3e0);
      var attributeByte  = _attributeBuffer[attributeIndex];

      var color;
      if (_pixelBuffer[idx] == 1) {
        color = _colorMap[attributeByte & 0x07];
      } else {
        color = _colorMap[(attributeByte >> 3) & 0x07];
      }
      
      _imageData.data[idx*4 + 0] = color['r'];
      _imageData.data[idx*4 + 1] = color['g'];
      _imageData.data[idx*4 + 2] = color['b'];
      _imageData.data[idx*4 + 3] = 0xff;
    }
        
    _context.putImageData(_imageData, 0, 0);
  }
}
