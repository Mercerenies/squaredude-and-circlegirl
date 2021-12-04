
function CrackedToDeathAnimation(_owner, _sx, _sy, _sz) constructor {
  owner = _owner; // Should have part_system and part_emitter fields.
  sx = _sx;
  sy = _sy;
  sz = _sz;
  progress = 0;

  static step = function() {
    progress += 0.05;

    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);

    if (progress < 0.1) {
      part_emitter_region(owner.part_system, owner.part_emitter, screen_x - 24, screen_x + 24, screen_y - 72, screen_y + 24, ps_shape_rectangle, ps_distr_linear);
      part_emitter_burst(owner.part_system, owner.part_emitter, ctrl_Particles.cracked_block, 15);
    }

  }

  static onStart = function() {
    obj_World.moveCountUp();
    if (is_undefined(obj_World.getVisualsAt(sx, sy, sz))) {
      obj_World.setAt(sx, sy, sz, undefined);
      obj_World.setVisualsAt(sx, sy, sz, owner);
    }
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(owner, sx, sy, sz, undefined));
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    if (obj_World.getAt(sx, sy, sz) == owner) {
      obj_World.setAt(sx, sy, sz, undefined);
    }
    if (obj_World.getVisualsAt(sx, sy, sz) == owner) {
      obj_World.setVisualsAt(sx, sy, sz, undefined);
    }
  }

  static isDone = function() {
    return progress >= 1;
  }

}
