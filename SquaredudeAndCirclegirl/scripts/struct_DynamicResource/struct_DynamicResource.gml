
function DynamicResource(_owner) constructor {
  owner = weak_ref_create(_owner);

  isAlive = function() {
    return weak_ref_alive(owner);
  }

  deallocate = function() {
    // Default implementation is empty.
  }

}