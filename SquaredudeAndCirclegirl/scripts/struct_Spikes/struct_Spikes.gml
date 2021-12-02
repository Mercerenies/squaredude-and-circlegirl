
function Spikes() : WorldObject() constructor {
  sprite = spr_Spikes;

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);
  }

  static isSharp = function() {
    return true;
  }

}
