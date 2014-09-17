//   ___ _ _
//  / __| (_)_ _____
// | (__| | \ V / -_)
//  \___|_|_|\_/\___|
//
// The Dart Game Framework for ZX Spectrum inspired games.
//
// A Dart game engine for those ZX Spectrum inspired retro games.
//

part of clive;

int createAttribute({int ink, int paper, int bright}) {
  var attributeByte = 0;

  attributeByte |= ink != null ? (ink & 0x07) : 0;
  attributeByte |= paper != null ? ((paper & 0x07) << 3) : 0;
  attributeByte |= bright != null ? 0x40 : 0;

  return attributeByte;
}