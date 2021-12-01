
function Character() : WorldObject() constructor {
  facing_dir = Dir.Down;

  static getPainter = function() {
    // Abstract parent method.
    show_debug_message("Character.getPainter not implemented!");
    return new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);
  }

  static step = function(xx, yy, zz) {
    getPainter().step();

    var input_dir = Input.dirPressed();
    if (input_dir >= 0) {
      facing_dir = input_dir;
    }

  }

  static draw = function(xx, yy, zz) {
    var screenx = World.toCenterX(xx, yy, zz);
    var screeny = World.toCenterY(xx, yy, zz);
    getPainter().draw(screenx, screeny, facing_dir);
  }

}