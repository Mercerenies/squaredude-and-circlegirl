
// Background
var bw = sprite_get_width(spr_BackgroundTile);
var offset = (ctrl_Spinning.tick / 2) % bw - bw;
for (var bx = offset; bx < room_width; bx += bw) {
  for (var by = offset; by < room_height; by += bw) {
    draw_sprite(spr_BackgroundTile, 0, bx, by);
  }
}

// Foreground
for (var idx = 0; idx < WORLD_HEIGHT * WORLD_LENGTH * WORLD_WIDTH; idx++) {

  // Base object
  var value = world[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

  // Visuals
  value = visuals[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

  // Quantum
  value = quantum[idx];
  if (!is_undefined(value)) {
    value.quantumDraw();
  }

  // Attack
  value = attack[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

}
