
function Squaredude() : Character() constructor {
  painter = new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);

  static getPainter = function() {
    return painter;
  }

  static characterChannel = function() {
    return "Squaredude.characterChannel";
  }

}
