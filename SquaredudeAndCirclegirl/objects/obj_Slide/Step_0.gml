
if (falling > 0) {
  y += falling;
  falling += 0.2;
  if (y > room_height * 2) {
    instance_destroy();
  }
}