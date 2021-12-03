
///// Pushing this doesn't work; correct and test fully
function Crate(_sprite) : WorldObject() constructor {
  sprite = _sprite;
  active_animation = undefined;
  painter = new _Crate_Painter(self);

  static getFacingDir = function() {
    return Dir.Down; // Unused but the painter needs it to exist.
  }

  static getActiveElement = function() {
    return Element.None; // Unused but the painter needs it to exist.
  }

  static getPainter = function() {
    return painter;
  }

  static getSprite = function() {
    return sprite;
  }

  static setAnimation = function(anim) {
    anim.onStart();
    active_animation = anim;
  }

  static step = function() {
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
      var sx = World.toCenterX(xx, yy, zz);
      var sy = World.toCenterY(xx, yy, zz);
      painter.draw(sx, sy, getFacingDir());
    }
  }

  static isDoubleHeight = function() {
    return true;
  }

  // Tries to move in the given direction. Returns true if successful.
  static tryToMove = function(dir) {
    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(dir);
    var dy = sy + Dir_toY(dir);
    var dz = sz;

    if (canMoveTo(sx, sy, sz, dx, dy, dz)) {
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), undefined));
      var anim = new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      setAnimation(anim);
      return true;
    }

    return false;
  }

  static canMoveTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var aboveMe = obj_World.getCovering(sx, sy, sz + 2);
    if (!is_undefined(aboveMe)) {
      return false; // Too heavy; there's something on top of us
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
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz));
      return;
    }

  }

  static canBePushed = function() {
    return true;
  }

}

function _Crate_Painter(_crate) constructor {
  crate = _crate;

  static draw = function(screenx, screeny, dir, elt) {
    draw_sprite(crate.sprite, 0, screenx, screeny);
  }

}
