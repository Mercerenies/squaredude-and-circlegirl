
// TODO Forbid either character from moving if the other is dead.
function Character() : WorldObject() constructor {
  facing_dir = Dir.Down;
  active_animation = undefined;
  falling = 0;
  default_paint = new Paint();
  idle_paint = new IdlePaint();
  element = Element.None;

  part_system = part_system_create_layer("Instances", false);
  part_system_automatic_draw(part_system, false);
  part_emitter = part_emitter_create(part_system);

  static getPainter = function() {
    // Abstract parent method.
    show_debug_message("Character.getPainter not implemented!");
    return new CharacterPainter(spr_Squaredude_Head, spr_Squaredude_Body, 0);
  }

  static characterChannel = function() {
    return "Character.characterChannel";
  }

  static getActiveElement = function() {
    return element;
  }

  static setActiveElement = function(e) {
    element = e;
  }

  static getFacingDir = function() {
    return facing_dir;
  }

  static setFacingDir = function(d) {
    facing_dir = d;
  }

  static setAnimation = function(anim) {
    anim.onStart();
    active_animation = anim;
  }

  static isActiveCharacter = function() {
    return characterChannel() == obj_World.getChannel();
  }

  static step = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var screenx = World.toCenterX(xx, yy, zz);
    var screeny = World.toCenterY(xx, yy, zz);

    getPainter().step();

    if ((!obj_World.isMovingSomething()) && (!obj_World.isSomeoneDead()) && (isActiveCharacter())) {
      var input_dir = Input.dirPressed();
      if (input_dir >= 0) {
        var prev_dir = facing_dir;
        facing_dir = input_dir;
        tryToMove(prev_dir);
      } else if (Input.spacePressed()) {
        emitElement();
      }
    }

    if (!is_undefined(active_animation)) {
      active_animation.step();
      if (active_animation.isDone()) {
        var tmp = active_animation;
        active_animation = undefined;
        tmp.onEnd();
      }
    }

    var headX = getPainter().last_draw_head_x;
    var headY = getPainter().last_draw_head_y;
    var bodyX = getPainter().last_draw_body_x;
    var bodyY = getPainter().last_draw_body_y;
    switch (element) {
    case Element.None:
      break;
    case Element.Fire:
      part_emitter_region(part_system, part_emitter, headX - 8, headX + 8, headY - 16, headY - 8, ps_shape_ellipse, ps_distr_linear);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_fire, 80);
      break;
    case Element.Water:
      part_emitter_region(part_system, part_emitter, headX - 8, headX + 8, headY - 20, headY - 12, ps_shape_ellipse, ps_distr_linear);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_water, 80);
      break;
    case Element.Air:
      part_emitter_region(part_system, part_emitter, headX - 16, headX + 16, headY - 20, headY - 12, ps_shape_ellipse, ps_distr_linear);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_air, 40);
      break;
    case Element.Thunder:
      part_emitter_region(part_system, part_emitter, headX - 8, headX + 8, headY - 16, headY - 10, ps_shape_ellipse, ps_distr_linear);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_thunder, 100);
      break;
    }

  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    if (!is_undefined(active_animation)) {
      active_animation.draw();
    } else {
      var screenx = World.toCenterX(xx, yy, zz);
      var screeny = World.toCenterY(xx, yy, zz);
      var paint = default_paint;
      if (!isActiveCharacter()) {
        paint = idle_paint;
      }
      getPainter().draw(screenx, screeny, facing_dir, element, paint);
    }

    if (instanceof(active_animation) == "CharacterTransformAnimation") {
      active_animation.setupShader();
    }
    part_system_drawit(part_system);
    shader_reset();

  }

  // Tries to move in the current facing_dir. Returns whether successful.
  static tryToMove = function(prev_dir) {
    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(facing_dir);
    var dy = sy + Dir_toY(facing_dir);
    var dz = sz;

    if (canHopTo(sx, sy, sz, dx, dy, dz + 1)) {
      ctrl_UndoManager.pushStack(UndoCut);
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), prev_dir));
      setAnimation(new CharacterHopUpAnimation(self, sx, sy, sz, dx, dy, dz + 1));
      return true;
    }

    if (canWalkTo(sx, sy, sz, dx, dy, dz)) {
      ctrl_UndoManager.pushStack(UndoCut);
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), prev_dir));
      var atDest = obj_World.getCovering(dx, dy, dz);
      if (!is_undefined(atDest)) {
        // In this case, we already determined (in canWalkTo) that we
        // can push it, so do it.
        atDest.tryToMove(facing_dir);
      }
      var anim;
      if (is_undefined(obj_World.getCovering(dx, dy, dz - 1))) {
        // Hop if there's nothing below us.
        anim = new CharacterHopAnimation(self, sx, sy, sz, dx, dy, dz);
      } else {
        anim = new CharacterWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      }
      setAnimation(anim);
      return true;
    }

    return false;
  }

  static canWalkTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var atDest = obj_World.getCovering(dx, dy, dz);
    if (!is_undefined(atDest)) {
      // See if we can push the thing
      if (atDest.canBePushed()) {
        // Go one further in that direction
        var objx = atDest.getX();
        var objy = atDest.getY();
        var objz = atDest.getZ();
        if (atDest.canMoveTo(objx, objy, objz, objx + (dx - sx), objy + (dy - sy), objz + (dz - sz))) {
          return true;
        }
      }
      return false;
    }
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (!is_undefined(aboveDest)) {
      return false;
    }
    return true;
  }

  static canHopTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var belowDest = obj_World.getCovering(dx, dy, dz - 1);
    if (is_undefined(belowDest)) {
      return false;
    }
    var atDest = obj_World.getCovering(dx, dy, dz);
    if (!is_undefined(atDest)) {
      return false;
    }
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (!is_undefined(aboveDest)) {
      return false;
    }
    return true;
  }

  static onArrive = function() {
    // We just got somewhere.
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var below = obj_World.getCovering(xx, yy, zz - 1);

    // Let the thing below us know we're here
    if (!is_undefined(below)) {
      below.landedOn(self);
      // The thing might not exist anymore
      below = obj_World.getCovering(xx, yy, zz - 1);
    }

    // If we're at Z=0, then we're dead.
    if (zz == 0) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    // If there's nothing below us, then fall.
    if (is_undefined(below)) {
      falling += 1;
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz));
      return;
    }

    // If we're standing on spikes, then die.
    if (below.isSharp()) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    // If we're standing on an element panel, transform.
    var belowElt = below.elementPanelOn();
    if ((!is_undefined(belowElt)) && (element != belowElt)) {
      // TODO Animation
      setAnimation(new CharacterTransformAnimation(self, belowElt, method(self, self._onArrive_postContinuation)));
    } else {
      _onArrive_postContinuation();
    }
  }

  static _onArrive_postContinuation = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    // If we've fallen too far, then we're dead.
    if (falling > 2) {
      falling = 0;
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      return;
    }

    falling = 0;
  }

  static isDoubleHeight = function() {
    return true;
  }

  static landedOn = function(top) {
    // Oh no, we are crushed :(
    setAnimation(new CharacterDeathAnimation(self, getX(), getY(), getZ()));
  }

  static emitElement = function() {

    var dx = getX() + Dir_toX(facing_dir);
    var dy = getY() + Dir_toY(facing_dir);
    var dz = getZ();
    if (!World.inBounds(dx, dy, dz)) {
      return;
    }

    switch (element) {
    case Element.None:
      // Nothing to be done here.
      break;
    case Element.Fire:
      obj_World.setVisualsAt(dx, dy, dz, new FireVisuals(dx, dy, dz));
      break;
    case Element.Water:
      obj_World.setVisualsAt(dx, dy, dz, new WaterVisuals(dx, dy, dz));
      break;
    case Element.Air:
      obj_World.setVisualsAt(dx, dy, dz, new AirVisuals(dx, dy, dz));
      break;
    case Element.Thunder:
      obj_World.setVisualsAt(dx, dy, dz, new ThunderVisuals(dx, dy, dz));
      break;
    }

  }

}
