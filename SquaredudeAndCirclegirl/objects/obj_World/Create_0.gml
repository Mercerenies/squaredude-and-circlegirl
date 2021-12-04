
world = [];

// This array never shrinks and only grows. When things are "removed",
// they're replaced with undefined and reused as slots later. This is
// so we're not constantly reallocating array space.
visuals = [];

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

move = function(x1, y1, z1, x2, y2, z2) {
  var v = getAt(x1, y1, z1);
  setAt(x1, y1, z1, undefined);
  setAt(x2, y2, z2, v);
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