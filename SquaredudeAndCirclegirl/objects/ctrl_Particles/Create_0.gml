
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
