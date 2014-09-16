//   ___ _ _
//  / __| (_)_ _____
// | (__| | \ V / -_)
//  \___|_|_|\_/\___|
//
// The Dart Game Framework for ZX Spectrum inspired games.
//
// A Dart game engine for those ZX Spectrum inspired retro games.
//

// Converts PNG-files to a Tile-based format.

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart';

void usage() {
  print('Usage : png_to_resource <def.json> <output.dart>');
}

void main(List<String> args) {

  if (args.length != 2) {
    usage();
    return;
  }

  var spriteDefinition;
  Image spriteImage;

  try {
    var data = new File(args[0]).readAsStringSync();
    spriteDefinition = JSON.decode(data);
    spriteImage = decodeImage(new File(spriteDefinition['image']).readAsBytesSync());
  } on FileSystemException catch(e) {
    print('Unable to read ${args[0]}');
    return;
  } on FormatException catch(e) {
    print('File ${args[0]} not valid JSON format.');
    return;
  }

  // Todo : check width/height/length.

  var spriteBytes = spriteImage.getBytes();
  var out = "import 'package:clive/clive.dart' as Clive;\n";
  out += "import 'dart:typed_data';\n\n";

  spriteDefinition['tiles'].forEach((tile) {

    var pixel = new Uint8List(tile['height'] * tile['width']);

    for (var y=0; y<tile['height']; y++) {
      for (var x=0; x<tile['width']; x++) {
        var idx1 = (x + tile['x'] + ((y + tile['y'])*spriteImage.width)) * 4;

        var color =
          (spriteBytes[idx1+0] << 16) +
          (spriteBytes[idx1+1] << 8)+
          spriteBytes[idx1+2];
        var transparent = spriteBytes[idx1+3];

        var idx2 = x + y*tile['width'];

        if (color > 0x7fffff) {
          pixel[idx2] = 1;
        } else {
          pixel[idx2] = 0;
        }

        if (transparent < 0x7f) {
          // pixel[idx2] = 2;
        }
      }
    }

    var name = tile['name'];

    var pixelC = new List();
    var lastByte = -1;
    var count = 1;

    for (var idx=0; idx<pixel.length; idx++) {
      if ((pixel[idx] == lastByte) && (count < 254)) {
        count++;
      } else {
        if (lastByte != -1) {
          if (count > 2) {
            pixelC.add(count);
            pixelC.add(lastByte);
          } else {
            pixelC.add(lastByte);
            if (count == 2) {
              pixelC.add(lastByte);
            }
          }
        }

        count = 1;
        lastByte = pixel[idx];
      }
    }

    out += 'var ${name}Pixel = new Uint8List.fromList(${pixelC});\n';
    out += 'var ${name}Sprite = new Clive.Sprite(${tile['width']}, ${tile['height']}';
    out += ', ${name}Pixel);\n\n';
  });

  try {
    new File(args[1]).writeAsStringSync(out);
  } on FileSystemException catch(e) {
    print('Unable to write to ${args[1]}');
    return;
  }
}