
undo_stack = ds_stack_create();

pushStack = function(event) {
  ds_stack_push(undo_stack, event);
}

backtrack = function() {
  while (!ds_stack_empty(undo_stack)) {
    var curr = ds_stack_pop(undo_stack);
    if (curr == UndoCut) {
      break;
    } else {
      curr.run();
    }
  }
}
