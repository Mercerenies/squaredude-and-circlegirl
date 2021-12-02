
// Precondition: dz == sz
function CharacterHopAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) constructor {
  owner = _owner;
  sx = _sx;
  sy = _sy;
  sz = _sz;
  dx = _dx;
  dy = _dy;
  dz = _dz;
  progress = 0;

  static step = function() {
    var prev_progress = progress;
    progress += 0.05;
    if ((prev_progress < 0.5) && (progress >= 0.5)) {
      obj_World.move(sx, sy, sz, dx, dy, dz);
    }
  }

  static onStart = function() {
    obj_World.moveCountUp();
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    owner.onArrive(dx, dy, dz);
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_sx = World.toCenterX(sx, sy, sz);
    var screen_sy = World.toCenterY(sx, sy, sz);
    var screen_dx = World.toCenterX(dx, dy, dz);
    var screen_dy = World.toCenterY(dx, dy, dz);

    var screen_x = lerp(screen_sx, screen_dx, progress);
    var screen_y = lerp(screen_sy, screen_dy, progress);
    // Hop anim
    screen_y -= GRID_SIZE * 4 * progress * (1 - progress);

    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir());

  }

}
