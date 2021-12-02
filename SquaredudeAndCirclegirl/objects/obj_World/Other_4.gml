
// DEBUG CODE
for (var xx = 0; xx < WORLD_WIDTH; xx++) {
  for (var yy = 0; yy < WORLD_LENGTH; yy++) {
    if ((xx != 6) || (yy != 1)) {
      setAt(xx, yy, 0, new Wall(spr_SimpleTile));
    }
  }
}
setAt(2, 2, 1, new Squaredude());
setAt(2, 5, 1, new Circlegirl());

setAt(9, 1, 0, new Spikes());

setAt(4, 4, 1, new Wall(spr_SimpleTile));
setAt(4, 4, 2, new Wall(spr_SimpleTile));

setAt(7, 4, 1, new Wall(spr_SimpleTile));
setAt(7, 4, 2, new Wall(spr_SimpleTile));
setAt(7, 4, 3, new Wall(spr_SimpleTile));
setAt(8, 4, 1, new Wall(spr_SimpleTile));
setAt(8, 4, 2, new Wall(spr_SimpleTile));
setAt(9, 4, 1, new Wall(spr_SimpleTile));
