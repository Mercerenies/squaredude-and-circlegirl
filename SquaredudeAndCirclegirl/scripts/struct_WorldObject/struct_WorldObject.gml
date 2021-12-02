
function WorldObject() constructor {
  xpos = -1;
  ypos = -1;
  zpos = -1;

  static setPosition = function(xx, yy, zz) {
    xpos = xx;
    ypos = yy;
    zpos = zz;
  }

  static getX = function() {
    return xpos;
  }

  static getY = function() {
    return ypos;
  }

  static getZ = function() {
    return zpos;
  }

  static step = function() {
    // Default implementation is empty.
  }

  static draw = function(xx, yy, zz) {
    // Default implementation is empty.
  }

  static isDoubleHeight = function() {
    return false;
  }

  // Called when something lands on top of this object.
  static landedOn = function(top) {
    // Default implementation is empty.
  }

}
