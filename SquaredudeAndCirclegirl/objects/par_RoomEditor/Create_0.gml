
whatLayer = function() {
  return real(string_digits(layer_get_name(layer)));
}

whereAmIX = function() {
  return x div GRID_SIZE;
}

whereAmIY = function() {
  var yy = y - 144 + (GRID_SIZE / 2) * whatLayer();
  return yy div GRID_SIZE
}

whereAmIZ = function() {
  return whatLayer();
}

loadSelf = function() {
  // Initially empty.
}