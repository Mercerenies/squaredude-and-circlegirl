
function Character() : WorldObject() constructor {
  facing_dir = Dir.Down;
  active_animation = undefined;
  falling = 0;
  default_paint = new Paint();
  idle_paint = new IdlePaint();

  static getPainter = function() {
    // Abstract parent method.
    show_debug_message("Character.getPainter not implemented!");
    return new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);
  }

  static characterChannel = function() {
    return "Character.characterChannel";
  }

  static getFacingDir = function() {
    return facing_dir;
  }

  static setAnimation = function(anim) {
    anim.onStart();
    active_animation = anim;
  }

  static isActiveCharacter = function() {
    return characterChannel() == obj_World.getChannel();
  }

  static step = function() {

    getPainter().step();

    var input_dir = Input.dirPressed();
    if ((input_dir >= 0) && (!obj_World.isMovingSomething()) && (isActiveCharacter())) {
      facing_dir = input_dir;
      tryToMove();
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

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    if (!is_undefined(active_animation)) {
      active_animation.draw();
    } else {
      var screenx = World.toCenterX(xx, yy, zz);
      var screeny = World.toCenterY(xx, yy, zz);
      var paint = default_paint;
      if (!isActiveCharacter()) {
        paint = idle_paint;
      }
      getPainter().draw(screenx, screeny, facing_dir, paint);
    }
  }

  // Tries to move in the current facing_dir.
  static tryToMove = function() {
    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(facing_dir);
    var dy = sy + Dir_toY(facing_dir);
    var dz = sz;

    if (canWalkTo(sx, sy, sz, dx, dy, dz)) {
      var anim;
      if (is_undefined(obj_World.getCovering(dx, dy, dz - 1))) {
        // Hop if there's nothing below us.
        anim = new CharacterHopAnimation(self, sx, sy, sz, dx, dy, dz);
      } else {
        anim = new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      }
      setAnimation(anim);
      return;
    }

    if (canHopTo(sx, sy, sz, dx, dy, dz + 1)) {
      setAnimation(new CharacterHopUpAnimation(self, sx, sy, sz, dx, dy, dz + 1));
      return;
    }

  }

  static canWalkTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var atDest = obj_World.getCovering(dx, dy, dz);
    if (!is_undefined(atDest)) {
      return false;
    }
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (!is_undefined(aboveDest)) {
      return false;
    }
    return true;
  }

  static canHopTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var atDest = obj_World.getCovering(dx, dy, dz);
    if (!is_undefined(atDest)) {
      return false;
    }
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (!is_undefined(aboveDest)) {
      return false;
    }
    return true;
  }

  static onArrive = function() {
    // We just got somewhere.
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var below = obj_World.getCovering(xx, yy, zz - 1);

    // Let the thing below us know we're here
    if (!is_undefined(below)) {
      below.landedOn(self);
      // The thing might not exist anymore
      below = obj_World.getCovering(xx, yy, zz - 1);
    }

    // If we're at Z=0, then we're dead.
    if (zz == 0) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    // If there's nothing below us, then fall.
    if (is_undefined(below)) {
      falling += 1;
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz));
      return;
    }

    // If we're standing on spikes, then die.
    if (below.isSharp()) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    // If we've fallen too far, then we're dead.
    if (falling > 2) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    falling = 0;

  }

  static isDoubleHeight = function() {
    return true;
  }

  static landedOn = function(top) {
    // Oh no, we are crushed :(
    setAnimation(new CharacterDeathAnimation(self, getX(), getY(), getZ()));
  }

  // TODO If something (including another character) falls on us, we
  // need to make sure we die.

}
