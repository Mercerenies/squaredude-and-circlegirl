
function Wall(_sprite, _element) : WorldObject() constructor {
  sprite = _sprite;
  element = _element;

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);
    if (!is_undefined(element)) {
      draw_sprite(spr_ElementPanel, element, sx, sy - GRID_SIZE / 2);
    }
  }

  static elementPanelOn = function() {
    return element;
  }

}
