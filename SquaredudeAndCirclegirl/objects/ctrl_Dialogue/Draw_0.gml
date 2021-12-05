
var from_bottom = 200;

if (dia_index < array_length(dia)) {
  var yy = room_height - from_bottom;

  var scolor = ((dia[dia_index].speaker == spr_Dia_Squaredude) ? c_white : c_gray);
  var ccolor = ((dia[dia_index].speaker == spr_Dia_Circlegirl) ? c_white : c_gray);

  draw_sprite_ext(spr_Dia_Squaredude, 0, room_width * 0.25, yy + 32, 1, 1, 0, scolor, 1);
  draw_sprite_ext(spr_Dia_Circlegirl, 0, room_width * 0.75, yy + 32, 1, 1, 0, ccolor, 1);

  draw_sprite(spr_DialogueBox, 0, room_width / 2, yy);
  draw_set_font(fnt_Dialogue);
  draw_set_color(c_white);
  draw_text_ext(32, yy + 32, display_text, -1, room_width - 64);

}