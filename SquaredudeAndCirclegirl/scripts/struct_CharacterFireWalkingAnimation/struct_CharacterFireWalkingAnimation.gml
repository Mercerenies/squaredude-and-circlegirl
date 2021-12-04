
// Same precondition as parent class
function CharacterFireWalkingAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) : CharacterWalkingAnimation(_owner, _sx, _sy, _sz, _dx, _dy, _dz) constructor {

  __CharacterWalkingAnimation_step = step;

  step = function() {
    __CharacterWalkingAnimation_step();
    var part_system = owner.part_system;
    var part_emitter = owner.part_emitter;
    var bodyX = owner.getPainter().last_draw_body_x;
    var bodyY = owner.getPainter().last_draw_body_y;
    part_emitter_region(part_system, part_emitter, bodyX - 8, bodyX + 8, bodyY - 8, bodyY + 8, ps_shape_ellipse, ps_distr_linear);
    part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_fire, 80);
  }

}
