
// This object acts as a makeshift garbage collector for dynamic
// resources such as particle systems. Using the methods on this
// object, functions can create dynamic resources and attach them to a
// struct. When the struct is freed (by the GC), this system will
// notice that at some point in the future and free the resource.

active = ds_list_create();

alarm[0] = 300;

// Takes a DynamicResource
attach = function(resource) {
  ds_list_add(active, resource);
}
