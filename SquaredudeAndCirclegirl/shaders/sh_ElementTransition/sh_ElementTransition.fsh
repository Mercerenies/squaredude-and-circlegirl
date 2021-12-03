//
// Fade to white (amount is 0.0 to 1.0, how faded)
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float amount;

void main()
{
    vec4 base_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    vec4 white = vec4(amount, amount, amount, 0.0);
    gl_FragColor = base_color + white - base_color * white;
}
