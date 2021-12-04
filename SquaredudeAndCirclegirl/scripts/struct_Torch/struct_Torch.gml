
function Torch(_channel) : WorldObject() constructor {
  sprite = spr_Torch;
  on_fire = false;
  channel = _channel;

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
      part_emitter_region(part_system, part_emitter, sx - 4, sx + 4, sy - 45, sy - 38, ps_shape_ellipse, ps_distr_gaussian);
      part_emitter_burst(part_system, part_emitter, ctrl_Particles.player_fire, 80);
    }
  }

  static draw = function() {
    var xx = getX();
    var yy = getY();
    var zz = getZ();

    var sx = World.toCenterX(xx, yy, zz);
    var sy = World.toCenterY(xx, yy, zz);
    draw_sprite(spr_Zodiac, channel, sx, sy + 8);
    draw_sprite(sprite, 0, sx, sy);
    part_system_drawit(part_system);
  }

  static isSharp = function() {
    return true;
  }

  static isDoubleHeight = function() {
    return true;
  }

  static hitWith = function(source, element) {
    if (element == Element.Fire) {
      ctrl_UndoManager.pushStack(new _Torch_OnFireEvent(self, self.on_fire));
      on_fire = true;
    } else if (element == Element.Water) {
      ctrl_UndoManager.pushStack(new _Torch_OnFireEvent(self, self.on_fire));
      on_fire = false;
    }
  }

  static burnAndSpreadFire = function() {
    // Can also catch fire from a nearby burning object, but torches do not
    // themselves spread the fire.
    ctrl_UndoManager.pushStack(new _Torch_OnFireEvent(self, self.on_fire));
    on_fire = true;
  }

  static updateMech = function() {
    if (on_fire) {
      obj_World.setMechChannel(channel, true);
    }
  }

}

function _Torch_OnFireEvent(_torch, _on_fire) : UndoEvent() constructor {
  torch = _torch;
  on_fire = _on_fire;
  static run = function() {
    torch.on_fire = on_fire;
  }
}
