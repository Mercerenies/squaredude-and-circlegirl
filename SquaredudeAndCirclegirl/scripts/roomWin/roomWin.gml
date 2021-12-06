
function roomWin() {
  audio_play_sound(snd_Win, 5, false);
  var currentRoom = real(string_digits(room_get_name(room)));
  saveGame(min(currentRoom + 1, 34));
  room_goto_next();
}
