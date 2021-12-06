
var tick = obj_Titletext.tick;

image_angle = 10 * sin(tick * 2 * pi / TITLE_PERIOD);
y = ystart - 25 * abs(sin(tick * 2 * pi / TITLE_PERIOD));
x = xstart - 10 * sin(tick * 2 * pi / TITLE_PERIOD);