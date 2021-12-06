
for (var i = 0; i < sprite_get_number(slideshow); i++) {
  arr[i] = instance_create_layer(room_width / 2, room_height / 2, "Instances_1", obj_Slide);
  arr[i].sprite_index = slideshow;
  arr[i].image_index = i;
}