
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

Input.spacePressed = function() {
  return keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
}

Input.shiftPressed = function() {
  return keyboard_check_pressed(vk_shift);
}

Input.escPressed = function() {
  return keyboard_check_pressed(vk_escape);
}

Input.backspacePressed = function() {
  return keyboard_check_pressed(vk_backspace);
}

Input.f1Pressed = function() {
  return keyboard_check_pressed(vk_f1);
}


Input.f5Pressed = function() {
  return keyboard_check_pressed(vk_f5);
}
