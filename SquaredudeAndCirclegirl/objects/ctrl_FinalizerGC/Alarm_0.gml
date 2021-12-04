
alarm[0] = 300;

for (var i = 0; i < ds_list_size(active); i++) {
  var resource = active[| i];
  if (!resource.isAlive()) {
    resource.deallocate();
    ds_list_delete(active, i);
    i--;
  }
}
