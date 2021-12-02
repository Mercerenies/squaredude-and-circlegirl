
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

  static draw = function(xorigin, yorigin, dir) {
    var xx, yy;

    // Body
    xx = xorigin;
    yy = yorigin + CHARACTER_BODY_OFFSET_Y - 3 * sin(anim_index * 2 * pi / 45);
    draw_sprite(body, dir, xx, yy);

    // Head
    xx = xorigin;
    yy = yorigin + CHARACTER_HEAD_OFFSET_Y - 3 * sin(anim_index * 2 * pi / 45 + pi / 3);
    draw_sprite(head, dir, xx, yy);

  }

}
