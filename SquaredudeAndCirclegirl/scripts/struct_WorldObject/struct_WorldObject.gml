
function WorldObject() constructor {

  static step = function(xx, yy, zz) {
    // Default implementation is empty.
  }

  static draw = function(xx, yy, zz) {
    // Default implementation is empty.
  }

  static isDoubleHeight = function() {
    return false;
  }

  // Called when something lands on top of this object.
  static landedOn = function(xx, yy, zz, top) {
    // Default implementation is empty.
  }

}
