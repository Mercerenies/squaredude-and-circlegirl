
function Wall(_sprite) : WorldObject() constructor {
  sprite = _sprite;

  static draw = function(xx, yy, zz) {
    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);
  }

}