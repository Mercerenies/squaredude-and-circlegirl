
// Precondition: dz == sz + 2
function CharacterHighJumpAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  dx = _dx;
  dy = _dy;
  dz = _dz;
  progress = 0;

  static step = function() {
    progress += 0.05;
  }

  static onStart = function() {
    obj_World.moveCountUp();
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));
    obj_World.move(sx, sy, sz, dx, dy, dz);
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    owner.onArrive(dx, dy, dz);
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_sx = World.toCenterX(sx, sy, sz);
    var screen_sy = World.toCenterY(sx, sy, sz);
    var screen_dx = World.toCenterX(dx, dy, sz); // Note: sz
    var screen_dy = World.toCenterY(dx, dy, sz); // Note: sz

    var screen_x = lerp(screen_sx, screen_dx, progress);
    var screen_y = lerp(screen_sy, screen_dy, progress);
    // Hop anim
    screen_y -= (GRID_SIZE * 4 * progress * (1 - progress) + GRID_SIZE * progress);

    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement());

  }

}
