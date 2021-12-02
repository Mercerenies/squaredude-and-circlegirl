
function CharacterDeathAnimation(_owner, _sx, _sy, _sz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  progress = 0;

  static step = function() {
    progress += 0.1;
  }

  static onStart = function() {
    obj_World.moveCountUp();
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    obj_World.setAt(sx, sy, sz, undefined);
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);

    draw_set_alpha(1 - progress);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir());
    draw_set_alpha(1);

  }

}
