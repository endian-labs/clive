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

class Engine {

  Canvas canvas;
  var gameCallback;
  List<Sprite> _sprites = new List();

  Engine(canvas_id) {
    canvas = new Canvas(canvas_id);
  }

  void addSprite(Sprite sprite) {
    _sprites.add(sprite);
  }

  void runGame(initCallback, gameCallback) {
    initCallback(this, canvas);
    canvas.snapshot();
    this.gameCallback = gameCallback;
    runLoop(0);
  }

  void runLoop(num time) {
    canvas.preUpdate();
    gameCallback(this, canvas);
    canvas.update(_sprites);
    window.requestAnimationFrame(runLoop);
  }
}
