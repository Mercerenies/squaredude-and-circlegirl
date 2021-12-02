
world = [];
move_count = 0;
channel_index = 0;
channels = [new Circlegirl().characterChannel(), new Squaredude().characterChannel()];

// Fill in reverse order so we only allocate memory once
for (var i = WORLD_WIDTH * WORLD_LENGTH * WORLD_HEIGHT - 1; i >= 0; i--) {
  world[i] = undefined;
}

_coord = function(xx, yy, zz) {
  return (xx * WORLD_LENGTH + yy) * WORLD_HEIGHT + zz;
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

getChannel = function() {
  return channels[channel_index];
}

cycleChannel = function() {
  channel_index = (channel_index + 1) % array_length(channels);
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
