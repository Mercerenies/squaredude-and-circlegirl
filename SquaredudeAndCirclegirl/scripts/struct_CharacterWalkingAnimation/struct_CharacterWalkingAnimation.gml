
// Precondition: sz == dz and abs(sx - dx) + abs(sy - dy) == 1
function CharacterWalkingAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  dx = _dx;
  dy = _dy;
  dz = _dz;
  progress = 0;
  move_dir = _determineDir();

  static step = function() {
    var prev_progress = progress;
    progress += 0.1;
    if ((prev_progress < 0.5) && (progress >= 0.5)) {
      // Do it halfway if going left or right
      if ((move_dir == Dir.Left) || (move_dir == Dir.Right)) {
        _performMoveAction();
      }
    }
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

  static _determineDir = function() {
    if (dx - sx > 0) {
      return Dir.Right;
    } else if (dx - sx < 0) {
      return Dir.Left;
    } else if (dy - sy > 0) {
      return Dir.Down;
    } else {
      return Dir.Up;
    }
  }

  static onStart = function() {
    obj_World.moveCountUp();
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));

    // Move first thing if going down
    if (move_dir == Dir.Down) {
      _performMoveAction();
    }
  }

  static onEnd = function() {
    obj_World.moveCountDown();

    // Move at the end if going up
    if (move_dir == Dir.Up) {
      _performMoveAction();
    }

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
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir());

  }

}
