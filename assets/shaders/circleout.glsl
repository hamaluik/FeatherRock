uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform vec2 resolutionCenter;
uniform float circleDistance;

void main() {
	vec2 delta = abs(gl_FragCoord.xy - resolutionCenter);
	gl_FragColor = color * texture2D(tex0, tcoord) * vec4(1.0 - step(circleDistance, length(delta)));
}
