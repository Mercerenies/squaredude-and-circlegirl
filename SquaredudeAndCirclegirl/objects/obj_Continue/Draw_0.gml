/// @description Insert description here
// You can write your code in this editor

draw_self();
if (ctrl_TitleManager.option == 1) {
  draw_sprite_ext(spr_Arrows, 1, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
  draw_set_font(fnt_LevelSelect);
  draw_set_color(c_black);
  draw_set_valign(fa_middle);
  draw_text(bbox_right + 16, mean(bbox_top, bbox_bottom), "(" + string(ctrl_TitleManager.continue_option + 1) + ")");
  draw_set_valign(fa_top);
}