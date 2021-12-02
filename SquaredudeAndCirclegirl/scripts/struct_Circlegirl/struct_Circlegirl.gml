
function Circlegirl() : Character() constructor {
  painter = new CharacterPainter(spr_Circlegirl_Head, spr_Circlegirl_Body, 0);

  static getPainter = function() {
    return painter;
  }

  static characterChannel = function() {
    return "Circlegirl.characterChannel";
  }

}
