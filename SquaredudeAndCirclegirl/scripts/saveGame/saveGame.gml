
function saveGame(index) {

  ini_open("squarecircle.dat");
  var saved = ini_read_real("game", "game", 0);
  ini_write_real("game", "game", max(saved, index));
  ini_close();

}
