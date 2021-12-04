
function QuantumBlock() : WorldObject() constructor {
  sprite = spr_QuantumBlock;

  originX = undefined;
  originY = undefined;
  originZ = undefined;

  prev_quantum_state = true;

  alpha = 1;

  // Public field
  quantum_state = true;

  static updateQuantumState = function() {
    var atOrigin = obj_World.getAt(originX, originY, originZ);
    if (quantum_state) {
      if (is_undefined(atOrigin)) {
        obj_World.setAt(originX, originY, originZ, self);
      }
    } else {
      if (atOrigin == self) {
        obj_World.setAt(originX, originY, originZ, undefined);
      }
      if (prev_quantum_state) {
        var above = obj_World.getCovering(originX, originY, originZ + 2);
        if (!is_undefined(above)) {
          // Check to see if the thing above us wants to fall down.
          above.onArrive();
        }
      }
    }
    prev_quantum_state = quantum_state;
  }

  static quantumStep = function() {
    if (obj_World.getAt(originX, originY, originZ) == self) {
      if (alpha < 1) {
        alpha += 0.05;
      }
    } else {
      if (alpha > 0) {
        alpha -= 0.05;
      }
    }
  }

  static quantumDraw = function() {
    var xx = originX;
    var yy = originY;
    var zz = originZ;

    draw_set_alpha(alpha);

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);

    draw_set_alpha(1);

  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

}
