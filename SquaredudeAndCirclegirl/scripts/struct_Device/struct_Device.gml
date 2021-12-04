
function Device(_channel) : WorldObject() constructor {
  sprite = spr_Device;
  active_animation = undefined;
  channel = _channel;
  state = 0;

  part_system = part_system_create_layer("Instances", false);
  part_system_automatic_draw(part_system, false);
  part_emitter = part_emitter_create(part_system);

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

    // Note: Doesn't draw the active animation (the only animation
    // that plays on this is ShockAnimation and it doesn't need to
    // draw)

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, state, sx, sy);
    draw_sprite(spr_Zodiac, channel, sx, sy - 48);
    part_system_drawit(part_system);
  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

  static hitWith = function(source, element) {
    if (element == Element.Thunder) {
      spreadShock();
    }
  }

  static spreadShock = function() {
    if (is_undefined(active_animation)) {
      var xx = getX();
      var yy = getY();
      var zz = getZ();
      setAnimation(new ShockAnimation(self, xx, yy, zz));

      ctrl_UndoManager.pushStack(new _Device_StatusEvent(self, state));
      state = 1 - state;

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

  static updateMech = function() {
    if (state > 0) {
      obj_World.setMechChannel(channel, state);
    }
  }

}

function _Device_StatusEvent(_device, _state) : UndoEvent() constructor {
  device = _device;
  state = _state;
  static run = function() {
    device.state = state;
  }
}
