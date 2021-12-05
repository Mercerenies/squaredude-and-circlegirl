
if ((Input.escPressed()) && (!showingDia())) {
  global.skipDia = true;
  room_restart();
}

if ((Input.backspacePressed()) && (!obj_World.isMovingSomething()) && (!showingDia())) {
  backtrack();
}
