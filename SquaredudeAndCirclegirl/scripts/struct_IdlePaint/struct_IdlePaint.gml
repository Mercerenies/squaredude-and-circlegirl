
function IdlePaint() : Paint() constructor {

/*
  static headX = function(anim_index) {
    return 0;
  }

  static headY = function(anim_index) {
    return CHARACTER_HEAD_OFFSET_Y - 2 * sin(anim_index * 2 * pi / 60 + pi / 3)
  }

  static headRot = function(anim_index) {
    return 0;
  }

  static bodyX = function(anim_index) {
    return 0;
  }

  static bodyY = function(anim_index) {
    return CHARACTER_BODY_OFFSET_Y - 2 * sin(anim_index * 2 * pi / 60);
  }

  static bodyRot = function(anim_index) {
    return 0;
  }
*/

  static bodyColor = function(anim_index) {
    return $999999;
  }

  static headColor = function(anim_index) {
    return $999999;
  }

}
