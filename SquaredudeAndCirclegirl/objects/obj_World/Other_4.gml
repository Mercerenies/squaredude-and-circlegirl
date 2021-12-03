
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

setAt(6, 3, 0, new Wall(spr_SimpleTile, Element.Fire));
setAt(6, 4, 0, new Wall(spr_SimpleTile, Element.Water));
setAt(6, 5, 0, new Wall(spr_SimpleTile, Element.Air));
setAt(6, 6, 0, new Wall(spr_SimpleTile, Element.Thunder));
setAt(6, 7, 0, new Wall(spr_SimpleTile, Element.None));

setAt(9, 1, 0, new Spikes());

setAt(8, 5, 1, new Crate(spr_WoodenCrate));
setAt(8, 4, 3, new Crate(spr_WoodenCrate));

setAt(4, 4, 1, new Wall(spr_SimpleTile));
setAt(4, 4, 2, new Wall(spr_SimpleTile));

setAt(7, 4, 1, new Wall(spr_SimpleTile));
setAt(7, 4, 2, new Wall(spr_SimpleTile));
setAt(7, 4, 3, new Wall(spr_SimpleTile));
setAt(8, 4, 1, new Wall(spr_SimpleTile));
setAt(8, 4, 2, new Wall(spr_SimpleTile));
setAt(9, 4, 1, new Wall(spr_SimpleTile));

setAt(7, 3, 1, new Wall(spr_SimpleTile));
setAt(7, 3, 2, new Wall(spr_SimpleTile));
setAt(7, 3, 3, new Wall(spr_SimpleTile));
setAt(8, 3, 1, new Wall(spr_SimpleTile));
setAt(8, 3, 2, new Wall(spr_SimpleTile));
setAt(9, 3, 1, new Wall(spr_SimpleTile));
