
function Crate(_sprite) : WorldObject() constructor {
  sprite = _sprite;
  active_animation = undefined;
  painter = new _Crate_Painter(self);
  launching = undefined; // Undefined or a direction constant

  part_system = part_system_create_layer("Instances", false);
  part_system_automatic_draw(part_system, false);
  part_emitter = part_emitter_create(part_system);

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

    part_system_drawit(part_system);

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

  static tryToLaunch = function(dir) {
    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(dir);
    var dy = sy + Dir_toY(dir);
    var dz = sz;

    var atDest = obj_World.getCovering(dx, dy, dz);
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (canLaunchTo(sx, sy, sz, dx, dy, dz)) {
      if (!is_undefined(atDest)) {
        atDest.setAnimation(new CharacterDeathAnimation(atDest, atDest.getX(), atDest.getY(), atDest.getZ()));
      }
      if ((!is_undefined(aboveDest)) && (aboveDest != atDest)) {
        aboveDest.setAnimation(new CharacterDeathAnimation(aboveDest, aboveDest.getX(), aboveDest.getY(), aboveDest.getZ()));
      }

      launching = dir;
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), undefined));
      var anim = new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      setAnimation(anim);
      return true;
    }

    var transitive = undefined;
    if ((!is_undefined(atDest)) && (is_undefined(aboveDest))) {
      transitive = atDest;
    } else if ((!is_undefined(aboveDest)) && (is_undefined(atDest))) {
      transitive = aboveDest;
    } else if ((!is_undefined(aboveDest)) && (atDest == aboveDest)) {
      transitive = aboveDest;
    }
    if (!is_undefined(transitive)) {
      transitive.onImpact(dir);
      // Don't want to trip again due to the same air effect, so fill
      // the animation slot with something useless for a few frames.
      setAnimation(new DelayAnimation(self, sx, sy, sz, 0.334));
    }

    launching = undefined;
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

  static canLaunchTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    if (canMoveTo(sx, sy, sz, dx, dy, dz)) {
      return true;
    }
    var aboveMe = obj_World.getCovering(sx, sy, sz + 2);
    if (!is_undefined(aboveMe)) {
      return false; // Too heavy; there's something on top of us
    }
    var atDest = obj_World.getCovering(dx, dy, dz);
    if ((!is_undefined(atDest)) && (!atDest.squishable())) {
      return false;
    }
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if ((!is_undefined(aboveDest)) && (!atDest.squishable())) {
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
      launching = undefined;
      return;
    }

    // If there's nothing below us, then fall.
    if (is_undefined(below)) {
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz));
      return;
    }

    // If we're standing on flames, then die.
    if (below.isFlaming() && (sprite == spr_WoodenCrate)) {
      burnAndSpreadFire();
      launching = undefined;
      return;
    }

    // Continue moving
    if (!is_undefined(launching)) {
      tryToLaunch(launching);
    }

  }

  static canBePushed = function() {
    return true;
  }

  static hitWith = function(source, element) {
    if ((element == Element.Fire) && (sprite == spr_WoodenCrate)) {
      burnAndSpreadFire();
    }
    if ((element == Element.Thunder) && (sprite == spr_MetalCrate)) {
      spreadShock();
    }
    if ((element == Element.Air) && (is_undefined(active_animation))) {
      // Launch
      var launch_dir;
      if (getX() > source.getX()) {
        launch_dir = Dir.Right;
      } else if (getX() < source.getX()) {
        launch_dir = Dir.Left;
      } else if (getY() > source.getY()) {
        launch_dir = Dir.Down;
      } else {
        launch_dir = Dir.Up;
      }
      tryToLaunch(launch_dir);
    }
  }

  static burnAndSpreadFire = function() {
    if ((sprite == spr_WoodenCrate) && (is_undefined(active_animation))) {
      var xx = getX();
      var yy = getY();
      var zz = getZ();
      setAnimation(new BurningToDeathAnimation(self, xx, yy, zz));

      // Spread the fire
      for (var x1 = xx - 1; x1 <= xx + 1; x1++) {
        for (var y1 = yy - 1; y1 <= yy + 1; y1++) {
          for (var z1 = zz - 1; z1 <= zz + 2; z1++) {
            // At least two coordinates must match
            var xmatch = (x1 == xx) ? 1 : 0;
            var ymatch = (y1 == yy) ? 1 : 0;
            var zmatch = (z1 == zz) ? 1 : 0;
            if (xmatch + ymatch + zmatch >= 2) {
              var adjacent = obj_World.getCovering(x1, y1, z1);
              if (!is_undefined(adjacent)) {
                adjacent.burnAndSpreadFire();
              }
            }
          }
        }
      }

      var above = obj_World.getCovering(xx, yy, zz + 2);
      if (!is_undefined(above)) {
        // Check to see if the thing above us wants to fall down.
        above.onArrive();
      }

    }
  }

  static spreadShock = function() {
    if ((sprite == spr_MetalCrate) && (is_undefined(active_animation))) {
      var xx = getX();
      var yy = getY();
      var zz = getZ();
      setAnimation(new ShockAnimation(self, xx, yy, zz));

      // Spread the shock
      for (var x1 = xx - 1; x1 <= xx + 1; x1++) {
        for (var y1 = yy - 1; y1 <= yy + 1; y1++) {
          for (var z1 = zz - 1; z1 <= zz + 2; z1++) {
            // At least two coordinates must match
            var xmatch = (x1 == xx) ? 1 : 0;
            var ymatch = (y1 == yy) ? 1 : 0;
            var zmatch = (z1 == zz) ? 1 : 0;
            if (xmatch + ymatch + zmatch >= 2) {
              var adjacent = obj_World.getCovering(x1, y1, z1);
              if (!is_undefined(adjacent)) {
                adjacent.spreadShock();
              }
            }
          }
        }
      }

    }
  }

  static onImpact = function(dir) {
    tryToLaunch(dir);
  }

}

function _Crate_Painter(_crate) constructor {
  crate = _crate;

  static draw = function(screenx, screeny, dir, elt) {
    draw_sprite(crate.sprite, 0, screenx, screeny);
  }

}
