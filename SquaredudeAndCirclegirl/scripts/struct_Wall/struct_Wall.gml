
function Wall(_sprite, _element, _plate_channel, _arrow_panel, _shape_panel, _check) : WorldObject() constructor {
  sprite = _sprite;
  element = _element;
  plate_channel = _plate_channel;
  arrow_panel = _arrow_panel;
  shape_panel = _shape_panel;
  check = _check;
  cached_index = -1;
  if (is_undefined(check)) {
    check = false;
  }

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

  static step = function() {
    if (check) {
      var above = obj_World.getAt(getX(), getY(), getZ() + 1);
      var occupied = ((instanceof(above) == "Squaredude") || (instanceof(above) == "Circlegirl"));
      if (!occupied) {
        obj_World.game_set_match = false;
      }
    }
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    var idx = _calcIndex();
    draw_sprite(sprite, idx, sx, sy);
    if (!is_undefined(element)) {
      draw_sprite(spr_ElementPanel, element, sx, sy - GRID_SIZE / 2);
    }
    if (!is_undefined(plate_channel)) {
      var pressed = platePressed();
      draw_sprite(spr_PressurePlate, pressed, sx, sy - GRID_SIZE / 2);
      draw_sprite(spr_Zodiac, plate_channel, sx, sy - GRID_SIZE / 2 - 8 + pressed * 8);
    }
    if (!is_undefined(arrow_panel)) {
      draw_sprite(spr_ArrowPanel, arrow_panel, sx, sy - GRID_SIZE / 2);
    }
    if (!is_undefined(shape_panel)) {
      draw_sprite(shape_panel, 0, sx, sy - GRID_SIZE / 2);
    }
    if (check) {
      var above = obj_World.getAt(getX(), getY(), getZ() + 1);
      var occupied = ((instanceof(above) == "Squaredude") || (instanceof(above) == "Circlegirl"));
      draw_sprite(spr_CheckPanel, occupied ? 1 : 0, sx, sy - GRID_SIZE / 2);
    }
  }

  static _calcIndex = function() {
    if (sprite != spr_SimpleTile) {
      return 0;
    }
    if (cached_index >= 0) {
      return cached_index;
    }

    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var r = (instanceof(obj_World.getAt(xx + 1, yy, zz)) == "Wall");
    var d = (instanceof(obj_World.getAt(xx, yy + 1, zz)) == "Wall");
    var l = (instanceof(obj_World.getAt(xx - 1, yy, zz)) == "Wall");
    var u = (instanceof(obj_World.getAt(xx, yy - 1, zz)) == "Wall");
    cached_index = r + 2 * d + 4 * l + 8 * u;
    return cached_index;
  }

  static elementPanelOn = function() {
    return element;
  }

  static getArrow = function() {
    return arrow_panel;
  }

  static shapePanel = function() {
    return shape_panel;
  }

}
