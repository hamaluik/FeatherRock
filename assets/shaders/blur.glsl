// adapted from https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson5

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float blur;
uniform vec2 dir;

void main() {
	vec4 sum = vec4(0.0);

	// gaussian
	sum += texture2D(tex0, vec2(tcoord.x - 4.0*blur*dir.x, tcoord.y - 4.0*blur*dir.y)) * 0.0162162162;
	sum += texture2D(tex0, vec2(tcoord.x - 3.0*blur*dir.x, tcoord.y - 3.0*blur*dir.y)) * 0.0540540541;
	sum += texture2D(tex0, vec2(tcoord.x - 2.0*blur*dir.x, tcoord.y - 2.0*blur*dir.y)) * 0.1216216216;
	sum += texture2D(tex0, vec2(tcoord.x - 1.0*blur*dir.x, tcoord.y - 1.0*blur*dir.y)) * 0.1945945946;

	sum += texture2D(tex0, vec2(tcoord.x, tcoord.y)) * 0.2270270270;

	sum += texture2D(tex0, vec2(tcoord.x + 1.0*blur*dir.x, tcoord.y + 1.0*blur*dir.y)) * 0.1945945946;
	sum += texture2D(tex0, vec2(tcoord.x + 2.0*blur*dir.x, tcoord.y + 2.0*blur*dir.y)) * 0.1216216216;
	sum += texture2D(tex0, vec2(tcoord.x + 3.0*blur*dir.x, tcoord.y + 3.0*blur*dir.y)) * 0.0540540541;
	sum += texture2D(tex0, vec2(tcoord.x + 4.0*blur*dir.x, tcoord.y + 4.0*blur*dir.y)) * 0.0162162162;

	gl_FragColor = color * sum;
}
