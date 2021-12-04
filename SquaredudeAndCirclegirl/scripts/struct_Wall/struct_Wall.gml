
function Wall(_sprite, _element, _plate_channel) : WorldObject() constructor {
  sprite = _sprite;
  element = _element;
  plate_channel = _plate_channel;

  static platePressed = function() {
    var above = obj_World.getCovering(getX(), getY(), getZ() + 1);
    return !is_undefined(above);
  }

  static updateMech = function() {
    if (!is_undefined(plate_channel)) {
      if (platePressed()) {
        obj_World.setMechChannel(plate_channel, true);
      }
    }
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);
    if (!is_undefined(element)) {
      // TODO Animate me (maybe a global color tint for this, or some particles?)
      draw_sprite(spr_ElementPanel, element, sx, sy - GRID_SIZE / 2);
    }
    if (!is_undefined(plate_channel)) {
      var pressed = platePressed();
      draw_sprite(spr_PressurePlate, pressed, sx, sy - GRID_SIZE / 2);
      draw_sprite(spr_Zodiac, plate_channel, sx, sy - GRID_SIZE / 2 - 8 + pressed * 8);
    }
  }

  static elementPanelOn = function() {
    return element;
  }

}
