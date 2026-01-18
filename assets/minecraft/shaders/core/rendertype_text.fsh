#version 150

in vec4 vertexColor;
in vec2 texCoord0;
in vec4 texColor;

uniform sampler2D Sampler0;
uniform vec4 ColorModulator;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    
    int r = int(texColor.r * 255.0 + 0.5);
    int g = int(texColor.g * 255.0 + 0.5);
    int b = int(texColor.b * 255.0 + 0.5);
    int a = int(texColor.a * 255.0 + 0.5);
    
    if (r >= 246 && r <= 254 && g == 255 && b == 0 && a == 255) {
        discard;
    }
    
    if (color.a < 0.1) {
        discard;
    }
    
    fragColor = color;
}