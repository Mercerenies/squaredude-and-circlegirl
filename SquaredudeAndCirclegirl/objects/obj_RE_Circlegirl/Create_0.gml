
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  var char = new Circlegirl();
  obj_World.circlegirl = char;
  obj_World.setAt(xx, yy, zz, char);
}
