
var text;
if (tick < 3) {
  text = "Designed by Mercerenies";
} else {
  text = "For the GMC Jam 43";
}

var a = clamp(1.5 - abs((tick % 3) - 1.5), 0, 1);

draw_set_font(fnt_LevelSelect);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(a);
draw_set_color(c_white);
draw_text(room_width / 2, room_height / 2, text);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);