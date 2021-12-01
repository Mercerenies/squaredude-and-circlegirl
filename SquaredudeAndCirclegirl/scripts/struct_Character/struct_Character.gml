
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
      var dx = xx + Dir_toX(input_dir);
      var dy = yy + Dir_toY(input_dir);
      active_animation = new CharacterWalkingAnimation(self, xx, yy, zz, dx, dy, zz);
      obj_World.moveCountUp();
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

}