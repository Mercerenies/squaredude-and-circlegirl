
enum Dir {
  Right = 0,
  Down = 1,
  Left = 2,
  Up = 3,
}

function Dir_toX(dir) {
  if (dir == Dir.Right) {
    return 1;
  } else if (dir == Dir.Left) {
    return -1;
  } else {
    return 0;
  }
}

function Dir_toY(dir) {
  if (dir == Dir.Down) {
    return 1;
  } else if (dir == Dir.Up) {
    return -1;
  } else {
    return 0;
  }
}