
function Character() : WorldObject() constructor {
  facing_dir = Dir.Down;
  active_animation = undefined;

  static getPainter = function() {
    // Abstract parent method.
    show_debug_message("Character.getPainter not implemented!");
    return new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);
  }

  static getFacingDir = function() {
    return facing_dir;
  }

  static setAnimation = function(anim) {
    anim.onStart();
    active_animation = anim;
  }

  static step = function(xx, yy, zz) {
    getPainter().step();

    var input_dir = Input.dirPressed();
    if ((input_dir >= 0) && (!obj_World.isMovingSomething())) {
      facing_dir = input_dir;
      tryToMove(xx, yy, zz);
    }

    if (!is_undefined(active_animation)) {
      active_animation.step();
      if (active_animation.isDone()) {
        var tmp = active_animation;
        active_animation = undefined;
        tmp.onEnd();
      }
    }

  }

  static draw = function(xx, yy, zz) {
    if (!is_undefined(active_animation)) {
      active_animation.draw();
    } else {
      var screenx = World.toCenterX(xx, yy, zz);
      var screeny = World.toCenterY(xx, yy, zz);
      getPainter().draw(screenx, screeny, facing_dir);
    }
  }

  // Tries to move in the current facing_dir.
  static tryToMove = function(sx, sy, sz) {
    var dx = sx + Dir_toX(facing_dir);
    var dy = sy + Dir_toY(facing_dir);
    var dz = sz;
    if (canWalkTo(sx, sy, sz, dx, dy, dz)) {
      setAnimation(new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz));
    }
  }

  static canWalkTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var atDest = obj_World.getAt(dx, dy, dz);
    if (!is_undefined(atDest)) {
      return false;
    }
    var aboveDest = obj_World.getAt(dx, dy, dz + 1);
    if (!is_undefined(aboveDest)) {
      return false;
    }
    return true;
  }

  static onArrive = function(xx, yy, zz) {
    // We just got somewhere.

    // If we're at Z=0, then we're dead.
    if (zz == 0) {
      // TODO Animation
      obj_World.setAt(xx, yy, zz, undefined);
    }

    // If there's nothing below us, then fall.
    var below = obj_World.getAt(xx, yy, zz - 1);
    if (is_undefined(below)) {
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz));
    }

  }

}
