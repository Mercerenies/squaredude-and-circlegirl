
// Background
var bw = sprite_get_width(spr_BackgroundTile);
var offset = (ctrl_Spinning.tick / 2) % bw - bw;
for (var bx = offset; bx < room_width; bx += bw) {
  for (var by = offset; by < room_height; by += bw) {
    draw_sprite(spr_BackgroundTile, 0, bx, by);
  }
}
