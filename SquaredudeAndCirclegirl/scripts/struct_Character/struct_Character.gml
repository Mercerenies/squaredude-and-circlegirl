
function Character() : WorldObject() constructor {
  facing_dir = Dir.Down;
  active_animation = undefined;
  falling = 0;
  default_paint = new Paint();
  idle_paint = new IdlePaint();
  shocked_paint = new ShockedPaint();
  shocked_idle_paint = new ShockedIdlePaint();
  element = Element.None;
  launching = undefined; // Undefined or a direction constant
  flying = false;
  shocked = false;

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
    obj_World.updateQuantumStates();
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
        obj_World.updateQuantumStates();
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

    if (shocked) {
      part_emitter_region(part_system, part_emitter, bodyX - 24, bodyX + 24, bodyY - 24, bodyY + 24, ps_shape_rectangle, ps_distr_invgaussian);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.static_thunder, 180);
    }

  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    if ((shocked) && (ctrl_Spinning.tick % 30 > 15)) {
      shader_set(sh_Shock);
    }
    if (!is_undefined(active_animation)) {
      active_animation.draw();
    } else {
      var screenx = World.toCenterX(xx, yy, zz);
      var screeny = World.toCenterY(xx, yy, zz);
      var paint = default_paint;
      if ((!isActiveCharacter()) && (shocked)) {
        paint = shocked_idle_paint;
      } else if (shocked) {
        paint = shocked_paint;
      } else if (!isActiveCharacter()) {
        paint = idle_paint;
      }
      getPainter().draw(screenx, screeny, facing_dir, element, paint);
    }
    shader_reset();

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
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      shocked = false;
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
      if ((is_undefined(obj_World.getCovering(dx, dy, dz - 1))) && (!shocked)) {
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

  static tryToHighJump = function(dir) {
    ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), facing_dir));
    facing_dir = dir;

    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(facing_dir);
    var dy = sy + Dir_toY(facing_dir);
    var dz = sz + 2;

    if (canHighJumpTo(sx, sy, sz, dx, dy, dz)) {
      // Note: falling = -2 so we don't take fall damage simply for missing the jump
      falling = -2;
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      shocked = false;
      setAnimation(new CharacterHighJumpAnimation(self, sx, sy, sz, dx, dy, dz));
    } else {
      // Failed, just show a small hop and go nowhere
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      shocked = false;
      setAnimation(new CharacterHopAnimation(self, sx, sy, sz, sx, sy, sz));
    }

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

  static canHighJumpTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
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

  static tryToLaunch = function(dir, initial, do_fly) {
    var sx = getX();
    var sy = getY();
    var sz = getZ();

    var dx = sx + Dir_toX(dir);
    var dy = sy + Dir_toY(dir);
    var dz = sz;

    var atDest = obj_World.getCovering(dx, dy, dz);
    var aboveDest = obj_World.getCovering(dx, dy, dz + 1);
    if (canLaunchTo(sx, sy, sz, dx, dy, dz)) {
      launching = dir;
      flying = do_fly;
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), facing_dir));
      facing_dir = dir;
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      shocked = false;
      var anim = new CharacterFireWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      if (flying) {
        anim = new CharacterAirWalkingAnimation(self, sx, sy, sz, dx, dy, dz);
      }
      setAnimation(anim);
      return true;
    }

    var transitive = undefined;
    if ((!is_undefined(atDest)) && (is_undefined(aboveDest))) {
      transitive = atDest;
    } else if ((!is_undefined(aboveDest)) && (is_undefined(atDest))) {
      transitive = aboveDest;
    } else if ((!is_undefined(aboveDest)) && (atDest == aboveDest)) {
      transitive = aboveDest;
    }
    if (!is_undefined(transitive)) {
      var strength = Strength.PlayerRunning;
      if (initial || do_fly) {
        strength = Strength.PlayerFlying;
      }
      transitive.onImpact(dir, strength);
      // Don't want to trip again due to the same effect, so fill
      // the animation slot with something useless for a few frames.
      setAnimation(new DelayAnimation(self, sx, sy, sz, 0.334));
    }

    launching = undefined;
    flying = false;
    return false;
  }

  static canLaunchTo = function(sx, sy, sz, dx, dy, dz) {
    if (!World.inBounds(dx, dy, dz)) {
      return false;
    }
    var aboveMe = obj_World.getCovering(sx, sy, sz + 2);
    if (!is_undefined(aboveMe)) {
      return false; // Too heavy; there's something on top of us
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
      launching = undefined;
      flying = false;
      return;
    }

    // If there's nothing below us, then fall.
    if ((is_undefined(below)) && (!flying)) {
      if (element != Element.Air) {
        falling += 1;
      }
      setAnimation(new CharacterFallingAnimation(self, xx, yy, zz, element == Element.Air));
      return;
    }

    // If we're standing on spikes, then die.
    if ((!is_undefined(below)) && (below.isSharp()) && (!flying)) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      launching = undefined;
      flying = false;
      return;
    }

    // If we're standing on an element panel, transform.
    var belowElt = (is_undefined(below) ? undefined : below.elementPanelOn());
    if ((!is_undefined(belowElt)) && (element != belowElt)) {
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      shocked = false;
      setAnimation(new CharacterTransformAnimation(self, belowElt, method(self, self._onArrive_postContinuation)));
    } else {
      _onArrive_postContinuation();
    }
  }

  static _onArrive_postContinuation = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var below = obj_World.getCovering(xx, yy, zz - 1);
    var quantumBelow = obj_World.getQuantumAt(xx, yy, zz - 1);

    // If we have an element, passively use it on the ground below
    if ((element != Element.None) && (element != Element.Air) && (!is_undefined(below))) {
      // Note: Air would be far too chaotic if allowed here.
      if ((instanceof(below) != "Squaredude") && (instanceof(below) != "Circlegirl")) {
        below.hitWith(self, element);
      }
    }
    if ((element != Element.None) && (element != Element.Air) && (!is_undefined(quantumBelow))) {
      // Note: Air would be far too chaotic if allowed here.
      quantumBelow.hitWith(self, element);
    }

    // If we're standing on flames, then die.
    if ((!is_undefined(below)) && below.isFlaming() && (element != Element.Fire) && (!flying)) {
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      launching = undefined;
      flying = false;
      return;
    }

    // If we've fallen too far, then we're dead.
    if (falling > 2) {
      falling = 0;
      setAnimation(new CharacterDeathAnimation(self, xx, yy, zz));
      launching = undefined;
      flying = false;
      return;
    }

    falling = 0;

    // Continue moving
    var prev_flying = flying;
    if (!is_undefined(launching)) {
      // Are we on an arrow panel?
      var arrow = (is_undefined(below) ? undefined : below.getArrow());
      if (!is_undefined(arrow)) {
        launching = arrow;
      }
      tryToLaunch(launching, false, flying);
    }

    if (is_undefined(launching) && prev_flying) {
      // If we were flying but we just hit something, then stop flying
      // and run this again to catch collisions on the ground.
      flying = false;
      onArrive();
    }
 }

  static isDoubleHeight = function() {
    return true;
  }

  static squishable = function() {
    return true;
  }

  static landedOn = function(top) {
    // Oh no, we are crushed :(
    setAnimation(new CharacterDeathAnimation(self, getX(), getY(), getZ()));
  }

  static hitWith = function(source, element) {
    var launch_dir;
    if (getX() > source.getX()) {
      launch_dir = Dir.Right;
    } else if (getX() < source.getX()) {
      launch_dir = Dir.Left;
    } else if (getY() > source.getY()) {
      launch_dir = Dir.Down;
    } else {
      launch_dir = Dir.Up;
    }
    if ((element == Element.Water) && (is_undefined(active_animation))) {
      // High jump
      tryToHighJump(launch_dir);
    }
    if ((element == Element.Fire) && (is_undefined(active_animation))) {
      // Flaming run
      tryToLaunch(launch_dir, true, false);
    }
    if ((element == Element.Air) && (is_undefined(active_animation))) {
      // Flaming run
      tryToLaunch(launch_dir, true, true);
    }
    if ((element == Element.Thunder) && (!shocked)) {
      // Shocked
      ctrl_UndoManager.pushStack(new _Character_ShockedEvent(self, shocked));
      ctrl_UndoManager.pushStack(new PlaceObjectUndoEvent(self, getX(), getY(), getZ(), facing_dir));
      facing_dir = launch_dir;
      shocked = true;
    }
  }

  static emitElement = function() {

    var dx = getX() + Dir_toX(facing_dir);
    var dy = getY() + Dir_toY(facing_dir);
    var dz = getZ();
    if (!World.inBounds(dx, dy, dz)) {
      return;
    }

    ctrl_UndoManager.pushStack(UndoCut);

    switch (element) {
    case Element.None:
      // Nothing to be done here.
      break;
    case Element.Fire:
      obj_World.setAttackAt(dx, dy, dz, new FireVisuals(dx, dy, dz));
      break;
    case Element.Water:
      obj_World.setAttackAt(dx, dy, dz, new WaterVisuals(dx, dy, dz));
      break;
    case Element.Air:
      obj_World.setAttackAt(dx, dy, dz, new AirVisuals(dx, dy, dz));
      break;
    case Element.Thunder:
      obj_World.setAttackAt(dx, dy, dz, new ThunderVisuals(dx, dy, dz));
      break;
    }

    if (element != Element.None) {
      var target;
      for (var zz = dz - 1; zz <= dz + 1; zz++) {
        target = obj_World.getCovering(dx, dy, zz);
        if (!is_undefined(target)) {
          target.hitWith(self, element);
        }
        // Flowers are in the quantum layer, so hit them too.
        target = obj_World.getQuantumAt(dx, dy, zz);
        if (!is_undefined(target)) {
          target.hitWith(self, element);
        }
      }
    }

  }

  static isLookingAt = function(dx, dy, dz) {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    if (xx < 0) {
      return false; // We're not on the map, so we're looking at nothing
    }

    if ((zz != dz) && (zz != dz - 1)) {
      return false; // Not aligned on Z
    }

    var dirx = Dir_toX(facing_dir);
    var diry = Dir_toY(facing_dir);
    if (dirx != 0) {
      // Facing horizontally, so check horizontal coordinates
      return sign(dx - xx) == dirx;
    } else {
      // Facing vertically, so check vertical coordinates
      return sign(dy - yy) == diry;
    }

  }

}

function _Character_ShockedEvent(_c, _shocked) : UndoEvent() constructor {
  c = _c;
  shocked = _shocked;
  static run = function() {
    c.shocked = shocked;
  }
}
