
for (var distance = WORLD_LENGTH + WORLD_HEIGHT - 1; distance >= 0; distance--) {
  for (var yy = 0; yy < WORLD_LENGTH; yy++) {
    // distance is the "distance" from the camera (taxicab distance, so it's a cube
    //not a sphere, and for our purposes we only care about one plane of this cube).
    //
    // Equation:
    // (WORLD_HEIGHT - zz) + (WORLD_LENGTH - yy) = distance
    //
    // Hence:
    // zz = (WORLD_HEIGHT - distance) + (WORLD_LENGTH - yy)
    //
    // As we iterate the inner loop, zz is getting smaller. So if it's too small,
    // stop iterating the inner loop.
    var zz = (WORLD_HEIGHT - distance) + (WORLD_LENGTH - yy);
    if (zz >= WORLD_HEIGHT) {
      continue;
    }
    if (zz < 0) {
      break;
    }
    // xx is easy; it just goes left-to-right
    for (var xx = 0; xx < WORLD_WIDTH; xx++) {
      var value = getAt(xx, yy, zz);
      if (!is_undefined(value)) {
        value.draw(xx, yy, zz);
      }
    }
  }
}

// ------------------------------------- //

for (var xx = 0; xx < WORLD_WIDTH; xx++) {
  for (var yy = 0; yy < WORLD_LENGTH; yy++) {
    if ((xx != 6) || (yy != 1)) {
      setAt(xx, yy, 0, new Wall(spr_SimpleTile));
    }
  }
}

setAt(6, 3, 0, new Wall(spr_SimpleTile, Element.Fire));
setAt(6, 4, 0, new Wall(spr_SimpleTile, Element.Water));
setAt(6, 5, 0, new Wall(spr_SimpleTile, Element.Air));
setAt(6, 6, 0, new Wall(spr_SimpleTile, Element.Thunder));
setAt(6, 7, 0, new Wall(spr_SimpleTile, Element.None));
setAt(6, 8, 0, new Wall(spr_SimpleTile, undefined, 2));

setAt(9, 1, 0, new Spikes());

setAt(8, 5, 1, new Crate(spr_WoodenCrate));
setAt(8, 3, 3, new Crate(spr_WoodenCrate));

setAt(12, 5, 1, new Crate(spr_MetalCrate));
setAt(12, 6, 1, new Crate(spr_MetalCrate));

setAt(4, 4, 1, new Wall(spr_SimpleTile));
setAt(4, 4, 2, new Wall(spr_SimpleTile));

setAt(7, 4, 1, new Wall(spr_SimpleTile));
setAt(7, 4, 2, new Wall(spr_SimpleTile));
setAt(7, 4, 3, new Wall(spr_SimpleTile));
setAt(8, 4, 1, new Wall(spr_SimpleTile));
setAt(8, 4, 2, new Wall(spr_SimpleTile));
setAt(9, 4, 1, new Wall(spr_SimpleTile));

setAt(7, 3, 1, new Wall(spr_SimpleTile));
setAt(7, 3, 2, new Wall(spr_SimpleTile));
setAt(7, 3, 3, new Wall(spr_SimpleTile));
setAt(8, 3, 1, new Wall(spr_SimpleTile));
setAt(8, 3, 2, new Wall(spr_SimpleTile));
setAt(9, 3, 1, new Wall(spr_SimpleTile));

setAt(11, 4, 0, new Burner(true));

setAt(10, 7, 1, new Wall(spr_SimpleTile));

var flower = new Flower();
flower.originX = 11;
flower.originY = 7;
flower.originZ = 1;
setQuantumAt(11, 7, 0, flower);

setAt(12, 7, 1, new Wall(spr_SimpleTile));
setAt(12, 7, 2, new Wall(spr_SimpleTile));
setAt(12, 7, 3, new Wall(spr_SimpleTile));

setAt(3, 7, 1, new Torch(2));
setAt(4, 7, 1, new Wall(spr_SimpleTile));

var door = new Door(2, false);
setAt(4, 8, 1, door);
setQuantumAt(4, 8, 0, door);
door.originX = 4;
door.originY = 8;
door.originZ = 1;

var door2 = new Door(3, false);
setAt(5, 8, 1, door2);
setQuantumAt(5, 8, 0, door2);
door2.originX = 5;
door2.originY = 8;
door2.originZ = 1;

setAt(10, 1, 1, new Device(3));

for (var i = 7; i <= 10; i++) {
  var quantum = new QuantumBlock();
  setAt(i, 2, 1, quantum);
  setQuantumAt(i, 2, 1, quantum);
  quantum.originX = i;
  quantum.originY = 2;
  quantum.originZ = 1;
}

setAt(14, 1, 0, new Wall(spr_SimpleTile, undefined, undefined, Dir.Down));
setAt(14, 12, 0, new Wall(spr_SimpleTile, undefined, undefined, Dir.Left));
setAt(13, 10, 1, new CrackedBlock());
setAt(15, 1, 0, new Wall(spr_SimpleTile, undefined, undefined, undefined, spr_SquarePanel));
setAt(15, 12, 0, new Wall(spr_SimpleTile, undefined, undefined, undefined, spr_CirclePanel));

setAt(16, 1, 0, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, true));
setAt(16, 12, 0, new Wall(spr_SimpleTile, undefined, undefined, undefined, undefined, true));
