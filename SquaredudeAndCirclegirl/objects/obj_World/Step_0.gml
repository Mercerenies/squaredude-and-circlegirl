
for (var yy = 0; yy < WORLD_LENGTH; yy++) {
  for (var zz = 0; zz < WORLD_HEIGHT; zz++) {
    for (var xx = 0; xx < WORLD_WIDTH; xx++) {
      var value = getAt(xx, yy, zz);
      if (!is_undefined(value)) {
        value.step();
      }
    }
  }
}