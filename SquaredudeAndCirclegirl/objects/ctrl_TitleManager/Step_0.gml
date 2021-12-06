
if (keyboard_check_pressed(vk_left) || (keyboard_check_pressed(vk_right))) {
  option = 1 - option;
}

if (option == 1) {
  if (keyboard_check_pressed(vk_up)) {
    continue_option = (continue_option + 1) % game_progress;
  } else if (keyboard_check_pressed(vk_down)) {
    continue_option = (continue_option + game_progress - 1) % game_progress;
  }
}

if (Input.spacePressed()) {
  var selection;
  if (option == 0) {
    selection = 1;
  } else {
    selection = continue_option + 1;
  }
  if (selection == 1) {
    // TODO Opening cutscene
    selection = "rm_L01";
  } else if (selection >= 10) {
    selection = "rm_L" + string(selection);
  } else {
    selection = "rm_L0" + string(selection);
  }
  var rm = asset_get_index(selection);
  if (room_exists(rm)) {
    room_goto(rm);
  }
}