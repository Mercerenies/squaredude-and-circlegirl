
function roomWin() {
  var currentRoom = real(string_digits(room_get_name(room)));
  saveGame(min(currentRoom + 1, 34));
  room_goto_next();
}
