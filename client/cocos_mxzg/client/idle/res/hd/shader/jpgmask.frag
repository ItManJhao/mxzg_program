
#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D u_maskTexture;

void main() {
    gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
    gl_FragColor.w = texture2D(u_maskTexture, v_texCoord).r;
}




