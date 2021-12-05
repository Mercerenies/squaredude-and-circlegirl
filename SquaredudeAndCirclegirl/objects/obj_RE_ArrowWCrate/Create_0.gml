
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();
  obj_World.setAt(xx, yy, zz, new Crate(spr_WoodenCrate, image_index));
}
