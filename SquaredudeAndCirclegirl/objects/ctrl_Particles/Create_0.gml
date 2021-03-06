
player_spawn_system = undefined;

player_fire = part_type_create();
part_type_shape(player_fire, pt_shape_pixel);
part_type_size(player_fire, 1, 1, 0, 0);
part_type_scale(player_fire, 1, 1);
part_type_speed(player_fire, 1, 2.5, 0, 0);
part_type_direction(player_fire, 70, 110, 0, 5);
part_type_gravity(player_fire, 0, 0);
part_type_orientation(player_fire, 0, 0, 0, 0, false);
part_type_colour3(player_fire, $2727a1, $7dced4, $8ddee4);
part_type_alpha3(player_fire, 1.0, 0.7, 0.0);
part_type_life(player_fire, 10, 20);

player_water = part_type_create();
part_type_shape(player_water, pt_shape_pixel);
part_type_size(player_water, 1, 2, 0, 0);
part_type_scale(player_water, 1, 1);
part_type_speed(player_water, 0.8, 1.9, 0, 0);
part_type_direction(player_water, 45, 135, 0, 5);
part_type_gravity(player_water, 0.2, 270);
part_type_orientation(player_water, 0, 360, 0, 0, false);
part_type_colour_mix(player_water, $baa720, $e6dd9b);
part_type_alpha1(player_water, 1.0);
part_type_life(player_water, 10, 20);

player_air = part_type_create();
part_type_shape(player_air, pt_shape_cloud);
part_type_size(player_air, 0.2, 0.2, 0, 0);
part_type_scale(player_air, 1, 1);
part_type_speed(player_air, 0, 0, 0, 0);
part_type_direction(player_air, 0, 0, 0, 0);
part_type_gravity(player_air, 0, 0);
part_type_orientation(player_air, 0, 360, 0, 0, false);
part_type_colour_mix(player_air, $d9d7cd, $b0ad99);
part_type_alpha1(player_air, 0.2);
part_type_life(player_air, 5, 15);

player_thunder = part_type_create();
part_type_shape(player_thunder, pt_shape_pixel);
part_type_size(player_thunder, 1, 1, 0, 0);
part_type_scale(player_thunder, 1, 1);
part_type_speed(player_thunder, 3, 3, 0, 0);
part_type_direction(player_thunder, 0, 180, 0, 0);
part_type_gravity(player_thunder, 0, 0);
part_type_orientation(player_thunder, 0, 0, 0, 0, false);
part_type_colour_mix(player_thunder, $6aebf8, $09bbcd);
part_type_alpha1(player_thunder, 1);
part_type_life(player_thunder, 5, 10);

attack_water = part_type_create();
part_type_shape(attack_water, pt_shape_pixel);
part_type_size(attack_water, 1, 2, 0, 0);
part_type_scale(attack_water, 1, 1);
part_type_speed(attack_water, 3.5, 4.0, 0, 0);
part_type_direction(attack_water, 45, 135, 0, 5);
part_type_gravity(attack_water, 0.2, 270);
part_type_orientation(attack_water, 0, 360, 0, 0, false);
part_type_colour_mix(attack_water, $baa720, $e6dd9b);
part_type_alpha1(attack_water, 1.0);
part_type_life(attack_water, 10, 20);

attack_air = part_type_create();
part_type_shape(attack_air, pt_shape_cloud);
part_type_size(attack_air, 0.2, 0.2, 0, 0);
part_type_scale(attack_air, 1, 1);
part_type_speed(attack_air, 0.5, 1.5, 0.2, 0);
part_type_direction(attack_air, 85, 95, 0, 0);
part_type_gravity(attack_air, 0, 0);
part_type_orientation(attack_air, 0, 360, 0, 0, false);
part_type_colour_mix(attack_air, $d9d7cd, $b0ad99);
part_type_alpha1(attack_air, 0.2);
part_type_life(attack_air, 5, 15);

attack_thunder = part_type_create();
part_type_shape(attack_thunder, pt_shape_pixel);
part_type_size(attack_thunder, 1, 1, 0, 0);
part_type_scale(attack_thunder, 1, 1);
part_type_speed(attack_thunder, 3, 3, 0, 0);
part_type_direction(attack_thunder, 0, 360, 0, 0);
part_type_gravity(attack_thunder, 0, 0);
part_type_orientation(attack_thunder, 0, 0, 0, 0, false);
part_type_colour_mix(attack_thunder, $6aebf8, $09bbcd);
part_type_alpha1(attack_thunder, 1);
part_type_life(attack_thunder, 5, 10);

static_thunder = part_type_create();
part_type_shape(static_thunder, pt_shape_pixel);
part_type_size(static_thunder, 1, 1, 0, 0);
part_type_scale(static_thunder, 1, 1);
part_type_speed(static_thunder, 2.5, 2.5, 0, 0);
part_type_direction(static_thunder, 0, 360, 0, 0);
part_type_gravity(static_thunder, 0, 0);
part_type_orientation(static_thunder, 0, 0, 0, 0, false);
part_type_colour_mix(static_thunder, $6aebf8, $09bbcd);
part_type_alpha1(static_thunder, 1);
part_type_life(static_thunder, 2, 4);

cracked_block = part_type_create();
part_type_sprite(cracked_block, spr_Cracked, false, false, false);
part_type_size(cracked_block, 0.5, 1, 0, 0);
part_type_scale(cracked_block, 1, 1);
part_type_speed(cracked_block, 1.5, 3.5, 0, 0);
part_type_direction(cracked_block, 60, 120, 0, 0);
part_type_gravity(cracked_block, 0.5, 270);
part_type_orientation(cracked_block, 0, 360, 0, 30, false);
part_type_colour1(cracked_block, c_white);
part_type_alpha1(cracked_block, 0.5);
part_type_life(cracked_block, 30, 50);
