
for (var idx = 0; idx < MECH_CHANNEL_COUNT; idx++) {
  mech_channels[idx] = false;
}

for (var idx = 0; idx < WORLD_HEIGHT * WORLD_LENGTH * WORLD_WIDTH; idx++) {

  // Base object
  var value = world[idx];
  if (!is_undefined(value)) {
    value.updateMech();
  }

}

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

  // Quantum
  value = quantum[idx];
  if (!is_undefined(value)) {
    value.quantumStep();
  }

  // Attack
  value = attack[idx];
  if (!is_undefined(value)) {
    value.step();
  }

}

updateQuantumStates();

// Check for shift
if ((Input.shiftPressed()) && (!isMovingSomething()) && (!isSomeoneDead())) {
  cycleChannel();
}

show_debug_message(move_count);
