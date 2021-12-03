
function CharacterTransformAnimation(_owner, _target_elem, _k) constructor {
  owner = _owner;
  target_elem = _target_elem;
  progress = 0;
  k = _k;

  static step = function() {
    var prev_progress = progress;
    progress += 0.05;
    if ((prev_progress < 0.5) && (progress >= 0.5)) {
      // Do it halfway if going left or right
      owner.setActiveElement(target_elem);
    }
  }

  static onStart = function() {
    obj_World.moveCountUp();
    ctrl_UndoManager.pushStack(new SetElementEvent(owner, owner.getActiveElement()));
  }

  static onEnd = function() {
    obj_World.moveCountDown();
    // Hacked together continuations :)
    k();
  }

  static isDone = function() {
    return progress >= 1;
  }

  static draw = function() {
    var sx = owner.getX();
    var sy = owner.getY();
    var sz = owner.getZ();
    var screen_x = World.toCenterX(sx, sy, sz);
    var screen_y = World.toCenterY(sx, sy, sz);

    shader_set(sh_ElementTransition);
    var amount_u = shader_get_uniform(sh_ElementTransition, "amount");
    var amount = sqrt(sin(progress * pi));
    shader_set_uniform_f(amount_u, amount);
    owner.getPainter().draw(screen_x, screen_y, owner.getFacingDir(), owner.getActiveElement());
    shader_reset();

  }

}
