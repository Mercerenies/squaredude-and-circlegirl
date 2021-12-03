
if (Input.escPressed()) {
  // TODO Don't replay tutorial dialogue if there was some
  room_restart();
}

if ((Input.backspacePressed()) && (!obj_World.isMovingSomething())) {
  backtrack();
}
