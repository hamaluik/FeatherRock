uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

void main() {
	gl_FragColor = color * texture2D(tex0, tcoord);
}
