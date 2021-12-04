
// We allocate a few "global" particle systems for each room.
player_spawn_system = part_system_create_layer("Instances", false);
part_system_automatic_draw(player_spawn_system, false);

player_spawn_emitter = part_emitter_create(player_spawn_system);