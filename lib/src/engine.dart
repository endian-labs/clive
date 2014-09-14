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

  Engine(canvas_id) {
    canvas = new Canvas(canvas_id);
  }

  void runGame(initCallback, gameCallback) {
    initCallback(canvas);
    canvas.snapshot();
    this.gameCallback = gameCallback;
    runLoop(0);
  }

  void runLoop(num time) {
    canvas.preUpdate();
    gameCallback(canvas);
    canvas.update();
    //window.requestAnimationFrame(runLoop);
  }
}
