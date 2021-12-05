
#macro MECH_CHANNEL_COUNT 13

world = [];
visuals = [];
quantum = [];
attack = [];

mech_channels = [];
game_set_match = false;

move_count = 0;
channel_index = 0;
channels = [new Circlegirl().characterChannel(), new Squaredude().characterChannel()];
// TODO Make sure these get set by whatever templating engine I use.
squaredude = undefined;
circlegirl = undefined;

// Fill in reverse order so we only allocate memory once
for (var i = WORLD_WIDTH * WORLD_LENGTH * WORLD_HEIGHT - 1; i >= 0; i--) {
  world[i] = undefined;
  visuals[i] = undefined;
  quantum[i] = undefined;
  attack[i] = undefined;
}

for (var i = 0; i < MECH_CHANNEL_COUNT; i++) {
  mech_channels[i] = false;
}

_coord = function(xx, yy, zz) {
  return (yy * WORLD_HEIGHT + zz) * WORLD_WIDTH + xx;
}

getAt = function(xx, yy, zz) {
  if (!World.inBounds(xx, yy, zz)) {
    return undefined;
  }
  return world[_coord(xx, yy, zz)];
}

// Get the thing at the position, or the thing immediately below if
// the below object is double-height.
getCovering = function(xx, yy, zz) {
  var v = getAt(xx, yy, zz);
  if (!is_undefined(v)) {
    return v;
  }
  v = getAt(xx, yy, zz - 1);
  if ((!is_undefined(v)) && (v.isDoubleHeight())) {
    return v;
  }
  return undefined;
}

setAt = function(xx, yy, zz, v) {
  if (World.inBounds(xx, yy, zz)) {
    var prev_v = world[_coord(xx, yy, zz)];
    if (!is_undefined(prev_v)) {
      prev_v.setPosition(-1, -1, -1);
    }
    if (!is_undefined(v)) {
      v.setPosition(xx, yy, zz);
    }
    world[_coord(xx, yy, zz)] = v;
  }
}

move = function(x1, y1, z1, x2, y2, z2) {
  var v = getAt(x1, y1, z1);
  setAt(x1, y1, z1, undefined);
  setAt(x2, y2, z2, v);
}

getVisualsAt = function(xx, yy, zz) {
  if (!World.inBounds(xx, yy, zz)) {
    return undefined;
  }
  return visuals[_coord(xx, yy, zz)];
}

setVisualsAt = function(xx, yy, zz, v) {
  if (World.inBounds(xx, yy, zz)) {
    visuals[_coord(xx, yy, zz)] = v;
  }
}

getQuantumAt = function(xx, yy, zz) {
  if (!World.inBounds(xx, yy, zz)) {
    return undefined;
  }
  return quantum[_coord(xx, yy, zz)];
}

setQuantumAt = function(xx, yy, zz, v) {
  if (World.inBounds(xx, yy, zz)) {
    quantum[_coord(xx, yy, zz)] = v;
  }
}

getAttackAt = function(xx, yy, zz) {
  if (!World.inBounds(xx, yy, zz)) {
    return undefined;
  }
  return attack[_coord(xx, yy, zz)];
}

setAttackAt = function(xx, yy, zz, v) {
  if (World.inBounds(xx, yy, zz)) {
    attack[_coord(xx, yy, zz)] = v;
  }
}

getChannel = function() {
  return channels[channel_index];
}

cycleChannel = function() {
  ctrl_UndoManager.pushStack(new SetActivePlayerEvent(channel_index));
  channel_index = (channel_index + 1) % array_length(channels);
}

setChannelIndex = function(idx) {
  channel_index = idx;
}

// We keep track of the number of objects moving in the game
// world. If it's greater than 0, then the player can't initiate
// motion. (TODO Checks for infinite cycles)

moveCountUp = function() {
  move_count += 1;
}

moveCountDown = function() {
  move_count -= 1;
}

isMovingSomething = function() {
  return move_count > 0;
}

isSomeoneDead = function() {
  return (squaredude.getX() < 0) || (circlegirl.getX() < 0);
}

updateQuantumStates = function() {
  for (var idx = 0; idx < WORLD_HEIGHT * WORLD_LENGTH * WORLD_WIDTH; idx++) {
    // Quantum
    value = quantum[idx];
    if (!is_undefined(value)) {
      // Note: idx = (yy * WORLD_HEIGHT + zz) * WORLD_WIDTH + xx;
      var xx = idx % WORLD_WIDTH;
      var yy = idx div (WORLD_WIDTH * WORLD_HEIGHT);
      var zz = (idx div WORLD_WIDTH) % WORLD_HEIGHT;
      var observed = (squaredude.isLookingAt(xx, yy, zz) || circlegirl.isLookingAt(xx, yy, zz));
      value.quantum_state = observed;
      value.updateQuantumState();
    }
  }
}

getMechChannel = function(idx) {
  return mech_channels[idx];
}

setMechChannel = function(idx, m) {
  mech_channels[idx] = m;
}
