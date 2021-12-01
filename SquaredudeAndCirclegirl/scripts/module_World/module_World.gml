
#macro WORLD_WIDTH 25
#macro WORLD_LENGTH 25
#macro WORLD_HEIGHT 5

#macro GRID_SIZE 48

#macro World global.__module_World

World = {};

World.inBounds = function(xx, yy, zz) {
  return (
    xx >= 0 && xx < WORLD_WIDTH &&
    yy >= 0 && yy < WORLD_LENGTH &&
    zz >= 0 && zz < WORLD_HEIGHT
  );
}

World.toScreenX = function(xx, yy, zz) {
  return xx * GRID_SIZE;
}

World.toScreenY = function(xx, yy, zz) {
  return (yy - zz / 2) * GRID_SIZE;
}

World.toCenterX = function(xx, yy, zz) {
  return World.toScreenX(xx, yy, zz) + GRID_SIZE / 2;
}

World.toCenterY = function(xx, yy, zz) {
  return World.toScreenY(xx, yy, zz) + GRID_SIZE / 2;
}
