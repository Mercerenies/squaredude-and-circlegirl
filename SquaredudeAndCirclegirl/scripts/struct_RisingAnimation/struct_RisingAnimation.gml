
function RisingAnimation(_owner, _sx, _sy, _sz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  dx = _sx;
  dy = _sy;
  dz = _sz + 2;
  progress = 0;

  static step = function() {
    progress += 0.1667; // Take six frames
  }

  static _performMoveAction = function() {

      // If there's something at the destination, assume we're pushing
      // it and throw it in the visuals layer for now.
      var obstacle = obj_World.getAt(dx, dy, dz);
      if (!is_undefined(obstacle)) {
        obj_World.setAt(dx, dy, dz, undefined);
        obj_World.setVisualsAt(dx, dy, dz, obstacle);
        obstacle.setPosition(dx, dy, dz); // Don't try this at home, kids.
      }

      // Remove from whichever layer we're in
      if (obj_World.getAt(sx, sy, sz) == owner) {
        obj_World.setAt(sx, sy, sz, undefined);
      }
      if (obj_World.getVisualsAt(sx, sy, sz) == owner) {
        obj_World.setVisualsAt(sx, sy, sz, undefined);
      }
      obj_World.setAt(dx, dy, dz, owner);

  }

  static onStart = function() {

    var occupying = obj_World.getAt(dx, dy, dz);
    if (!is_undefined(occupying)) {
      occupying.setAnimation(new RisingAnimation(occupying, dx, dy, dz));
    }

    obj_World.moveCountUp();
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));
    _performMoveAction();
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    owner.onArrive();
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_sx = World.toCenterX(sx, sy, sz);
    var screen_sy = World.toCenterY(sx, sy, sz);
    var screen_dx = World.toCenterX(dx, dy, dz);
    var screen_dy = World.toCenterY(dx, dy, dz);

    var screen_x = lerp(screen_sx, screen_dx, progress);
    var screen_y = lerp(screen_sy, screen_dy, progress);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement());

  }

}
