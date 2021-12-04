
function ShockAnimation(_owner, _sx, _sy, _sz) constructor {
  owner = _owner; // Should have part_system and part_emitter fields.
  sx = _sx;
  sy = _sy;
  sz = _sz;
  progress = 0;

  static step = function() {
    progress += 0.05;

    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);

    part_emitter_region(owner.part_system, owner.part_emitter, screen_x - 24, screen_x + 24, screen_y - 72, screen_y + 24, ps_shape_rectangle, ps_distr_invgaussian);
    part_emitter_burst(owner.part_system, owner.part_emitter, ctrl_Particles.static_thunder, 180);

  }

  static onStart = function() {
    obj_World.moveCountUp();
  }

  static onEnd = function() {
    obj_World.moveCountDown();
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);
    owner.getPainter().draw(screen_x, screen_y);
  }

}
