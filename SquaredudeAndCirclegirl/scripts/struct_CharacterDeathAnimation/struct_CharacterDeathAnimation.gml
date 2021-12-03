
function CharacterDeathAnimation(_owner, _sx, _sy, _sz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  progress = 0;
  custom_paint = new _CharacterDeathAnimation_Paint(self);

  static step = function() {
    progress += 0.05;
  }

  static onStart = function() {
    obj_World.moveCountUp();
    if (is_undefined(obj_World.getVisualsAt(sx, sy, sz))) {
      obj_World.setAt(sx, sy, sz, undefined);
      obj_World.setVisualsAt(sx, sy, sz, owner);
    }
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    if (obj_World.getAt(sx, sy, sz) == owner) {
      obj_World.setAt(sx, sy, sz, undefined);
    }
    if (obj_World.getVisualsAt(sx, sy, sz) == owner) {
      obj_World.setVisualsAt(sx, sy, sz, undefined);
    }
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);

    var a = 1 - 2 * max(progress - 0.5, 0);
    draw_set_alpha(a);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement(), custom_paint);
    draw_set_alpha(1);

  }

}

function _CharacterDeathAnimation_Paint(_owner) : Paint() constructor {
  owner = _owner;

  static headX = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return - 10 * p;
  }

  static headY = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return CHARACTER_HEAD_OFFSET_Y - 16 * p * (1 - p) + 16 * p;
  }

  static headRot = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return lerp(0, 90, p);
  }

  static bodyX = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return 10 * p;
  }

  static bodyY = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return CHARACTER_BODY_OFFSET_Y - 18 * p * (1 - p) + 2 * p;
  }

  static bodyRot = function(anim_index) {
    var p = 2 * min(owner.progress, 0.5);
    return lerp(0, -180, p);
  }

}
