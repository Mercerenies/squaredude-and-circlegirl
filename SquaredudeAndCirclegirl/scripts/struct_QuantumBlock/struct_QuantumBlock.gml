
function QuantumBlock() : WorldObject() constructor {
  sprite = spr_QuantumBlock;

  originX = undefined;
  originY = undefined;
  originZ = undefined;

  static step = function() {
    if (is_undefined(originX) && (getX() >= 0)) {
      originX = getX();
      originY = getY();
      originZ = getZ();
    }
    
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);

  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

}
