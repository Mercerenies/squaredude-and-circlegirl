
// Same precondition as parent class
function CharacterAirWalkingAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) : CharacterWalkingAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) constructor {

  __CharacterWalkingAnimation_step = step;

  step = function() {
    __CharacterWalkingAnimation_step();
    var part_system = owner.part_system;
    var part_emitter = owner.part_emitter;
    var bodyX = owner.getPainter().last_draw_body_x;
    var bodyY = owner.getPainter().last_draw_body_y;
    part_emitter_region(part_system, part_emitter, bodyX - 16, bodyX + 16, bodyY - 16, bodyY + 16, ps_shape_rectangle, ps_distr_linear);
    part_emitter_burst(part_system, part_emitter, ctrl_Particles.attack_air, 10);
  }

  static draw = function() {
    var screen_sx = World.toCenterX(sx, sy, sz);
    var screen_sy = World.toCenterY(sx, sy, sz);
    var screen_dx = World.toCenterX(dx, dy, dz);
    var screen_dy = World.toCenterY(dx, dy, dz);

    var dir = (ctrl_Spinning.tick div 5) % 4;

    var screen_x = lerp(screen_sx, screen_dx, progress);
    var screen_y = lerp(screen_sy, screen_dy, progress);
    owner.getPainter().draw(screen_x, screen_y, dir, owner.getActiveElement());

  }

}
