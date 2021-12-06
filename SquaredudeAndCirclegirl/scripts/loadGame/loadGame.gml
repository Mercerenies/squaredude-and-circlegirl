
function loadGame() {

  ini_open("squarecircle.dat");
  var saved = ini_read_real("game", "game", 1);
  ini_close();
  return saved;

}
