
#macro Input global.__module_Input

Input = {};

Input.dirPressed = function() {
  if (keyboard_check(vk_right)) {
    return Dir.Right;
  } else if (keyboard_check(vk_down)) {
    return Dir.Down;
  } else if (keyboard_check(vk_left)) {
    return Dir.Left;
  } else if (keyboard_check(vk_up)) {
    return Dir.Up;
  } else {
    return -1;
  }
}