
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
