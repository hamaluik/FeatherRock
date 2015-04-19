uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform float brightPassThreshold;

void main() {
	// isolate only the bright colours
	vec3 luminanceVector = vec3(0.2125, 0.7154, 0.0721);
	vec4 sample = texture2D(tex0, tcoord);

	float luminance = dot(luminanceVector, sample.rgb);
	luminance = max(0.0, luminance - brightPassThreshold);
	sample.rgb *= sign(luminance);
	//sample.a = 1.0;

	gl_FragColor = sample;
}
