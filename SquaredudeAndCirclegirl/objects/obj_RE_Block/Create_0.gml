
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  switch (image_index) {
  case 0:
    obj_World.setAt(xx, yy, zz, new CrackedBlock());
    break;
  case 1:
    obj_World.setAt(xx, yy, zz, new Crate(spr_WoodenCrate));
    break;
  case 2:
    obj_World.setAt(xx, yy, zz, new Crate(spr_MetalCrate));
    break;
  case 3:
    var quantum = new QuantumBlock();
    obj_World.setAt(xx, yy, zz, quantum);
    obj_World.setQuantumAt(xx, yy, zz, quantum);
    quantum.originX = xx;
    quantum.originY = yy;
    quantum.originZ = zz;
    break;
  }
}
