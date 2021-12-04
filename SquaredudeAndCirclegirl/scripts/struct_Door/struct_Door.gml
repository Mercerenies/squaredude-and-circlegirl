
// Doors should exist at (x, y, z) and then be placed at the quantum layer for (x, y, z - 1).
function Door(_channel, _up_when_on) : WorldObject() constructor {
  sprite = spr_Door;
  channel = _channel;
  up_when_on = _up_when_on;
  moving = false;

  // Set these to the object's actual position (not its quantum position)
  originX = -1;
  originY = -1;
  originZ = -1;

  image_idx = 6;

  static shouldBeUp = function() {
    var status = obj_World.getMechChannel(channel);
    return status ^ !up_when_on;
  }

  static updateQuantumState = function() {
    // Not really quantum, just faking it
  }

  static quantumStep = function() {
    if (moving) {
      if (shouldBeUp()) {
        image_idx++;
        if (image_idx == 6) {
          moving = false;
          obj_World.moveCountDown();
        }
      } else {
        image_idx--;
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
        ctrl_UndoManager.pushStack(new _Door_StatusEvent(self, false));
        moving = true;
        obj_World.moveCountUp();
        var occupying = obj_World.getAt(originX, originY, originZ);
        if (!is_undefined(occupying)) {
          occupying.setAnimation(new RisingAnimation(occupying, originX, originY, originZ));
        }
        obj_World.setAt(originX, originY, originZ, self);
      } else if ((!shouldBeUp()) && (image_idx > 0)) {
        ctrl_UndoManager.pushStack(new _Door_StatusEvent(self, true));
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
    draw_sprite(spr_Zodiac, channel, sx, sy - 8 * image_idx);

  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

}

function _Door_StatusEvent(_door, _state) : UndoEvent() constructor {
  door = _door;
  state = _state;
  static run = function() {
    door.image_idx = (state ? 6 : 0);
    if (state) {
      obj_World.setAt(door.originX, door.originY, door.originZ, door);
    } else {
      if (obj_World.getAt(door.originX, door.originY, door.originZ) == door) {
        obj_World.setAt(door.originX, door.originY, door.originZ, undefined);
      }
    }
  }
}
