
#macro CHARACTER_BODY_OFFSET_Y -6
#macro CHARACTER_HEAD_OFFSET_Y -30

// Pass the two sprites and the animation index.
function CharacterPainter(_head, _body, _anim_index) constructor {
  head = _head;
  body = _body;
  anim_index = _anim_index;

  static step = function() {
    anim_index += 1;
  }

  static draw = function(xorigin, yorigin, dir, paint) {
    var xx, yy, rot, color;

    if (is_undefined(paint)) {
      paint = new Paint();
    }

    var alpha = draw_get_alpha();

    // Body
    xx = xorigin + paint.bodyX(anim_index);
    yy = yorigin + paint.bodyY(anim_index);
    rot = paint.bodyRot(anim_index);
    color = paint.bodyColor(anim_index);
    draw_sprite_ext(body, dir, xx, yy, 1, 1, rot, color, alpha);

    // Head
    xx = xorigin + paint.headX(anim_index);
    yy = yorigin + paint.headY(anim_index);
    rot = paint.headRot(anim_index);
    color = paint.headColor(anim_index);
    draw_sprite_ext(head, dir, xx, yy, 1, 1, rot, color, alpha);

  }

}
