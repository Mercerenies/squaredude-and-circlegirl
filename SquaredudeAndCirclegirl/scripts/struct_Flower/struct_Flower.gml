
// Flowers should be placed at the quantum layer for (x, y, z - 1).
function Flower() : WorldObject() constructor {
  sprite = spr_Flower;
  moving = false;

  // Set these to the object's actual position (not its quantum position)
  originX = -1;
  originY = -1;
  originZ = -1;

  image_idx = 0;
  grown = false;

  static shouldBeUp = function() {
    return grown;
  }

  static updateQuantumState = function() {
    // Not really quantum, just faking it
  }

  static quantumStep = function() {
    if (moving) {
      if (shouldBeUp()) {
        image_idx += 0.5;
        if (image_idx == 6) {
          moving = false;
          obj_World.moveCountDown();
        }
      } else {
        image_idx -= 0.5;
        if (image_idx == 0) {
          moving = false;
          obj_World.moveCountDown();
          var above = obj_World.getCovering(originX, originY, originZ + 2);
          if (!is_undefined(above)) {
            above.onArrive();
          }
        }
      }
    } else {
      if ((shouldBeUp()) && (image_idx < 6)) {
        ctrl_UndoManager.pushStack(new _Flower_StatusEvent(self, false));
        moving = true;
        obj_World.moveCountUp();
        var occupying = obj_World.getAt(originX, originY, originZ);
        if (!is_undefined(occupying)) {
          occupying.setAnimation(new RisingAnimation(occupying, originX, originY, originZ, 0.08334)); // 12 frames
        }
        obj_World.setAt(originX, originY, originZ, self);
      } else if ((!shouldBeUp()) && (image_idx > 0)) {
        ctrl_UndoManager.pushStack(new _Flower_StatusEvent(self, true));
        moving = true;
        obj_World.moveCountUp();
        obj_World.setAt(originX, originY, originZ, undefined);
      }
    }
  }

  static quantumDraw = function() {
    var xx = originX;
    var yy = originY;
    var zz = originZ;

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, image_idx, sx, sy);

  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

  static hitWith = function(source, element) {
    if (element == Element.Water) {
      grown = true;
    }
  }

}

function _Flower_StatusEvent(_flower, _state) : UndoEvent() constructor {
  flower = _flower;
  state = _state;
  static run = function() {
    flower.grown = state;
    flower.image_idx = (state ? 6 : 0);
    if (state) {
      obj_World.setAt(flower.originX, flower.originY, flower.originZ, flower);
    } else {
      if (obj_World.getAt(flower.originX, flower.originY, flower.originZ) == flower) {
        obj_World.setAt(flower.originX, flower.originY, flower.originZ, undefined);
      }
    }
  }
}
