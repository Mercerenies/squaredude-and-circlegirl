
event_inherited();

plate_channel = 0;

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  for (var z1 = 0; z1 < zz; z1++) {
    obj_World.setAt(xx, yy, z1, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, false));
  }
  var device = new Device(plate_channel);
  device.state = image_index;
  obj_World.setAt(xx, yy, zz, device);
}
