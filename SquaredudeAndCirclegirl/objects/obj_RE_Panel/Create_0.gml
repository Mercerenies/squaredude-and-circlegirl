
event_inherited();

loadSelf = function() {
  var xx = whereAmIX();
  var yy = whereAmIY();
  var zz = whereAmIZ();

  var sprite_idx, check;
  switch (image_index) {
  case 0:
    sprite_idx = spr_CirclePanel;
    check = false;
    break;
  case 1:
    sprite_idx = spr_SquarePanel;
    check = false;
    break;
  case 2:
    sprite_idx = undefined;
    check = true;
    break;
  }

  for (var z1 = 0; z1 < zz; z1++) {
    obj_World.setAt(xx, yy, z1, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, false));
  }
  obj_World.setAt(xx, yy, z1, new Wall(spr_SimpleTile, undefined, undefined, undefined, sprite_idx, check));
}
