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
  
  Engine(canvas_id) {    
    canvas = new Canvas(canvas_id);
  }
  
  void runLoop(num time) {
    canvas.preUpdate();    
    canvas.update();
    window.requestAnimationFrame(runLoop);
  }
}
