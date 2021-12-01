
painter.step();

if (keyboard_check_pressed(vk_left)) {
  dir = Dir.Left;
} else if (keyboard_check_pressed(vk_right)) {
  dir = Dir.Right;
} else if (keyboard_check_pressed(vk_down)) {
  dir = Dir.Down;
} else if (keyboard_check_pressed(vk_up)) {
  dir = Dir.Up;
}