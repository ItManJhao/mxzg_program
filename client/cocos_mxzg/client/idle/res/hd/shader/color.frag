#ifdef GL_ES 
precision mediump float;
#endif 
varying vec4 v_fragmentColor; 
varying vec2 v_texCoord; 
uniform vec3 u_color;

void main(void) 
{ 
    vec4 c = texture2D(CC_Texture0, v_texCoord);
    if(c.r > 0.0)
    {
		gl_FragColor.xyz = u_color;
		gl_FragColor.w = c.w;
	}
	else
	{
		discard;
	} 
}