
function CrackedBlock() : WorldObject() constructor {
  sprite = spr_CrackedBlock;
  active_animation = undefined;

  part_system = part_system_create_layer("Instances", false);
  part_system_automatic_draw(part_system, false);
  part_emitter = part_emitter_create(part_system);

  static setAnimation = function(anim) {
    anim.onStart();
    active_animation = anim;
  }

  static step = function() {
    if (!is_undefined(active_animation)) {
      active_animation.step();
      if (active_animation.isDone()) {
        var tmp = active_animation;
        active_animation = undefined;
        tmp.onEnd();
      }
    }
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    // Note: Doesn't draw the active animation (the only animation
    // that plays on this is ShockAnimation and it doesn't need to
    // draw)

    if (xx >= 0) {
      var sx = World.toCenterX(xx, yy, zz);
      var sy = World.toCenterY(xx, yy, zz);
      draw_sprite(sprite, 0, sx, sy);
    }
    part_system_drawit(part_system);
  }

  static isDoubleHeight = function() {
    return true;
  }

  static canBePushed = function() {
    return false;
  }

  static onImpact = function(dir, strength) {
    if (strength >= Strength.PlayerRunning) {
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), undefined));
      setAnimation(new CrackedToDeathAnimation(self, getX(), getY(), getZ()));
    }
  }

}
