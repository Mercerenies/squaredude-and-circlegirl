
for (var idx = 0; idx < WORLD_HEIGHT * WORLD_LENGTH * WORLD_WIDTH; idx++) {

  // Base object
  var value = world[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

  // Visuals
  value = visuals[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

  // Quantum
  value = quantum[idx];
  if (!is_undefined(value)) {
    value.quantumDraw();
  }

  // Attack
  value = attack[idx];
  if (!is_undefined(value)) {
    value.draw();
  }

}
// TODO Shadows
