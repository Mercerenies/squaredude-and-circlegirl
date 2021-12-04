
function FireVisuals(_xx, _yy, _zz) constructor {
  obj_World.moveCountUp();
  xx = _xx;
  yy = _yy;
  zz = _zz;
  timer = 30;
  finished = false;

  step = function() {
    timer -= 1;
    if ((timer <= 0) && (!finished)) {
      finished = true;
      var obj = obj_World.getAttackAt(xx, yy, zz);
      if (obj == self) {
        obj_World.setAttackAt(xx, yy, zz, undefined);
      }
      obj_World.moveCountDown();
    }

    var screenx = World.toCenterX(xx, yy, zz);
    var screeny = World.toCenterY(xx, yy, zz);

    if (timer > 15) {
      // Spawn some particles
      part_emitter_region(ctrl_Particles.player_spawn_system, ctrl_Particles.player_spawn_emitter, screenx - 8, screenx + 8, screeny - 8, screeny + 8, ps_shape_ellipse, ps_distr_gaussian);
      part_emitter_burst(ctrl_Particles.player_spawn_system, ctrl_Particles.player_spawn_emitter, ctrl_Particles.player_fire, 80);
    }

  }

  draw = function() {
    part_system_drawit(ctrl_Particles.player_spawn_system);
  }

}
