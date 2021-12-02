
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
        active_animation = undefined;
        obj_World.moveCountDown();
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
    if (World.inBounds(dx, dy, dz)) {
      active_animation = new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      obj_World.moveCountUp();
    }
  }

}
