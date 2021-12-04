
function ParticleResource(_owner, _part_system) : DynamicResource(_owner) constructor {
  part_system = _part_system;

  deallocate = function() {
    part_system_destroy(part_system);
  }

}