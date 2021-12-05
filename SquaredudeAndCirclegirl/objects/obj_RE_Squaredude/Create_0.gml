
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  var char = new Squaredude();
  obj_World.squaredude = char;
  obj_World.setAt(xx, yy, zz, char);
}
