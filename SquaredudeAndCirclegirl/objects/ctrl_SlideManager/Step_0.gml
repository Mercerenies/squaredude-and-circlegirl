
if (arr_index >= array_length(arr)) {
  room_goto(dest);
} else if (Input.spacePressed()) {
  arr[arr_index].falling = 2;
  arr_index += 1;
}