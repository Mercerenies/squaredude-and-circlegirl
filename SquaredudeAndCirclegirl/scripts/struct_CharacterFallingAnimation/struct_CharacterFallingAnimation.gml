
function CharacterFallingAnimation(_owner, _sx, _sy, _sz, _slow) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  progress = 0;
  slow = _slow;
  if (is_undefined(slow)) {
    slow = false;
  }

  static step = function() {
    var prev_progress = progress;
    if (slow) {
      progress += 0.1;
    } else {
      progress += 0.2;
    }
    if ((prev_progress < 0.5) && (progress >= 0.5)) {
      obj_World.move(sx, sy, sz, sx, sy, sz - 1);
    }
  }

  static onStart = function() {
    obj_World.moveCountUp();
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    owner.onArrive(sx, sy, sz - 1);
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_sx = World.toCenterX(sx, sy, sz);
    var screen_sy = World.toCenterY(sx, sy, sz);
    var screen_dx = World.toCenterX(sx, sy, sz - 1);
    var screen_dy = World.toCenterY(sx, sy, sz - 1);

    var screen_x = lerp(screen_sx, screen_dx, progress);
    var screen_y = lerp(screen_sy, screen_dy, progress);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement());

  }

}
