
function Burner(_on_fire) : WorldObject() constructor {
  sprite = spr_Burner;
  on_fire = _on_fire;

  part_system = part_system_create_layer("Instances", false);
  part_system_automatic_draw(part_system, false);
  part_emitter = part_emitter_create(part_system);

  static step = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);

    if (on_fire) {
      part_emitter_region(part_system, part_emitter, sx - 24, sx + 24, sy - 48, sy - 0, ps_shape_rectangle, ps_distr_linear);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_fire, 120);
    }
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(sprite, 0, sx, sy);
    part_system_drawit(part_system);
  }

  static isFlaming = function() {
    return on_fire;
  }

  static hitWith = function(source, element) {
    if (element == Element.Fire) {
      burnAndSpreadFire();
    } else if (element == Element.Water) {
      ctrl_UndoManager.pushStack(new _Torch_OnFireEvent(self, self.on_fire));
      on_fire = false;
    }
  }

  static burnAndSpreadFire = function() {
    // Spreads fire up
    ctrl_UndoManager.pushStack(new _Torch_OnFireEvent(self, self.on_fire));
    on_fire = true;
    var above = obj_World.getCovering(getX(), getY(), getZ() + 1);
    if (!is_undefined(above)) {
      above.burnAndSpreadFire();
    }
  }

}

function _Burner_OnFireEvent(_torch, _on_fire) : UndoEvent() constructor {
  torch = _torch;
  on_fire = _on_fire;
  static run = function() {
    torch.on_fire = on_fire;
  }
}
