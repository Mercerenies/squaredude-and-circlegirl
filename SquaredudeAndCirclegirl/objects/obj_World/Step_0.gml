
for (var idx = 0; idx < WORLD_HEIGHT * WORLD_LENGTH * WORLD_WIDTH; idx++) {

  // Base object
  var value = world[idx];
  if (!is_undefined(value)) {
    value.step();
  }

  // Visuals
  value = visuals[idx];
  if (!is_undefined(value)) {
    value.step();
  }

}

// Check for shift
if ((Input.shiftPressed()) && (!isMovingSomething())) {
  cycleChannel(); // TODO Visual indicator of this
}

