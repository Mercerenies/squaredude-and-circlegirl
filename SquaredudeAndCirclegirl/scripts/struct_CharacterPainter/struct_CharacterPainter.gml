
#macro CHARACTER_BODY_OFFSET_Y -6
#macro CHARACTER_HEAD_OFFSET_Y -30

// Pass the two sprites and the animation index.
function CharacterPainter(_head, _body, _anim_index) constructor {
  head = _head;
  body = _body;
  anim_index = _anim_index;
  default_paint = new Paint();

  // Terrible hack :)
  //
  // These four are public fields
  last_draw_head_x = 0;
  last_draw_head_y = 0;
  last_draw_body_x = 0;
  last_draw_body_y = 0;

  static step = function() {
    anim_index += 1;
  }

  static getAnimIndex = function() {
    return anim_index;
  }

  static _determineImageIndex = function(dir, elt) {
    return elt * 4 + dir;
  }

  static draw = function(xorigin, yorigin, dir, elt, paint) {
    var xx, yy, rot, color;

    if (is_undefined(paint)) {
      paint = default_paint;
    }

    var alpha = draw_get_alpha();
    var img_index = _determineImageIndex(dir, elt);

    // Body
    last_draw_body_x = xorigin + paint.bodyX(anim_index);
    last_draw_body_y = yorigin + paint.bodyY(anim_index);
    rot = paint.bodyRot(anim_index);
    color = paint.bodyColor(anim_index);
    draw_sprite_ext(body, img_index, last_draw_body_x, last_draw_body_y, 1, 1, rot, color, alpha);

    // Head
    last_draw_head_x = xorigin + paint.headX(anim_index);
    last_draw_head_y = yorigin + paint.headY(anim_index);
    rot = paint.headRot(anim_index);
    color = paint.headColor(anim_index);
    draw_sprite_ext(head, img_index, last_draw_head_x, last_draw_head_y, 1, 1, rot, color, alpha);

  }

}
