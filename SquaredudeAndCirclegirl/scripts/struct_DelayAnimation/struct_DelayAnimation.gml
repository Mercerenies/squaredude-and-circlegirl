
function DelayAnimation(_owner, _sx, _sy, _sz, _spd) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  spd = _spd;
  progress = 0;

  static step = function() {
    progress += spd;
  }

  static onStart = function() {
    obj_World.moveCountUp();
  }

  static onEnd = function() {
    obj_World.moveCountDown();
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement());
  }

}
