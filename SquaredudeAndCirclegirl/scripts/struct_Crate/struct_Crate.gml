
function Crate(_sprite) : WorldObject() constructor {
  sprite = _sprite;
  active_animation = undefined;
  painter = new _Crate_Painter(self);

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

  static hitWith = function(source, element) {
    // TODO Time permitting, some cutesy animations for the other elements
    if ((element == Element.Fire) && (sprite == spr_WoodenCrate)) {
      burnAndSpreadFire();
    }
  }

  static burnAndSpreadFire = function() {
    if ((sprite == spr_WoodenCrate) && (instanceof(active_animation) != "BurningToDeathAnimation")) {
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

}

function _Crate_Painter(_crate) constructor {
  crate = _crate;

  static draw = function(screenx, screeny, dir, elt) {
    draw_sprite(crate.sprite, 0, screenx, screeny);
  }

}
