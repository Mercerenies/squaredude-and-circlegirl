
if (dia_index < array_length(dia)) {
  var text = dia[dia_index].text;
  display_text = string_copy(text, 1, string_length(display_text) + 1);

  if (Input.spacePressed()) {
    if (text == display_text) {
      dia_index += 1;
      display_text = "";
    } else {
      display_text = text;
    }
  }

} else {

  if ((Input.f1Pressed()) && (!obj_World.isMovingSomething())) {
    dia_index = 0;
    display_text = "";
  }

}