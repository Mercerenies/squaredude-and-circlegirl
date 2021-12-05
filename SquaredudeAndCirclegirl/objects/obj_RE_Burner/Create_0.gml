
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  for (var z1 = 0; z1 < zz; z1++) {
    obj_World.setAt(xx, yy, z1, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, false));
  }
  obj_World.setAt(xx, yy, z1, new Burner(image_index > 0));
}
