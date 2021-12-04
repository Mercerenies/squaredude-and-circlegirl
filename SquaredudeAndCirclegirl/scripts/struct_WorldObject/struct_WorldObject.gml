
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

  static isSharp = function() {
    return false;
  }

  static isFlaming = function() {
    return false;
  }

  static canBePushed = function() {
    // If this returns true, then the object should define
    // canMoveTo(sx, sy, sz, dx, dy, dz) and tryToMove(dir). See Crate
    // for example.
    return false;
  }

  static elementPanelOn = function() {
    // Note: Not all WorldObject's can support an elemental
    // panel. Consult the specific struct for details.
    // undefined means there is no panel. Element.None means
    // there is specifically the "none" panel.
    return undefined;
  }

  static onArrive = function() {
    // Empty
  }

  static onImpact = function(dir) {
    // Empty
  }

  // Called when hit with the given elemental ability
  static hitWith = function(source, element) {
    // Empty
  }

  static burnAndSpreadFire = function() {
    // Empty
  }

  static spreadShock = function() {
    // Empty
  }

  static updateMech = function() {
    // Empty
  }

  static squishable = function() {
    // If this is true, then the object can be crushed by oncoming crates.
    return false;
  }

  static getArrow = function() {
    return undefined;
  }

}
