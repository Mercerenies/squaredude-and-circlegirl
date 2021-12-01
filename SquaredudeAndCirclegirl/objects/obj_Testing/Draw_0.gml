
var grid_size = 48;

draw_set_color(c_dkgray);

for (var i = 0; i < room_width; i += grid_size) {
  draw_line(i, 0, i, room_height);
}

for (var j = 0; j < room_height; j += grid_size) {
  draw_line(0, j, room_width, j);
}