
function Character() : WorldObject() constructor {

  static getPainter = function() {
    // Abstract parent method.
    show_debug_message("Character.getPainter not implemented!");
    return new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);
  }

  static step = function() {
    getPainter().step();
  }

  static draw = function(xx, yy, zz) {
    var screenx = World.toCenterX(xx, yy, zz);
    var screeny = World.toCenterY(xx, yy, zz);
    getPainter().draw(screenx, screeny, Dir.Right);
  }

}