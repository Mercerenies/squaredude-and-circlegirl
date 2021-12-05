
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  for (var z1 = 0; z1 < zz; z1++) {
    obj_World.setAt(xx, yy, z1, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, false));
  }
  var flower = new Flower();
  obj_World.setQuantumAt(xx, yy, zz - 1, flower);
  flower.originX = xx;
  flower.originY = yy;
  flower.originZ = zz;
}
