
// DEBUG CODE
for (var xx = 0; xx < WORLD_WIDTH; xx++) {
  for (var yy = 0; yy < WORLD_LENGTH; yy++) {
    setAt(xx, yy, 0, new Wall(spr_SimpleTile));
  }
}
setAt(2, 2, 1, new Squaredude());