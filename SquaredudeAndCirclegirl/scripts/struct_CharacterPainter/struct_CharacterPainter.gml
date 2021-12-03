
#macro CHARACTER_BODY_OFFSET_Y -6
#macro CHARACTER_HEAD_OFFSET_Y -30

// Pass the two sprites and the animation index.
function CharacterPainter(_head, _body, _anim_index) constructor {
  head = _head;
  body = _body;
  anim_index = _anim_index;
  default_paint = new Paint();

  static step = function() {
    anim_index += 1;
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
    xx = xorigin + paint.bodyX(anim_index);
    yy = yorigin + paint.bodyY(anim_index);
    rot = paint.bodyRot(anim_index);
    color = paint.bodyColor(anim_index);
    draw_sprite_ext(body, img_index, xx, yy, 1, 1, rot, color, alpha);

    // Head
    xx = xorigin + paint.headX(anim_index);
    yy = yorigin + paint.headY(anim_index);
    rot = paint.headRot(anim_index);
    color = paint.headColor(anim_index);
    draw_sprite_ext(head, img_index, xx, yy, 1, 1, rot, color, alpha);

  }

}
