#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;
uniform float GameTime;

out vec4 vertexColor;
out vec2 texCoord0;
out vec4 texColor;

struct Transform {
    vec4 textureColor;
    vec3 position;
    vec4 screenOffset;
    vec2 screenSize;
} transform;

void screenAnchor(int marker, vec2 offset, int anchor) {
    int detectedMarker = int(transform.textureColor.r * 255.0 + 0.5);
    
    if (detectedMarker != marker) {
        return;
    }
    
    vec2 screen;
    
    switch(anchor) {
        case 0: 
            screen = vec2(-1.0, 2.0);
            break;
        case 1:
            screen = vec2(1.0, 2.0);
            break;
        case 2:
            screen = vec2(0.0, 2.0);
            break;
        case 3:
            screen = vec2(-1.0, 1.0);
            break;
        case 4:
            screen = vec2(1.0, 1.0);
            break;
        case 5:
            screen = vec2(0.0, 1.0);
            break;
        case 6:
            screen = vec2(-1.0, 0.0);
            break;
        case 7:
            screen = vec2(1.0, 0.0);
            break;
        case 8:
            screen = vec2(0.0, 0.0);
            break;
        default:
            return;
    }
    
    transform.position. x += offset.x;
    transform.position.y += offset.y;
    transform.screenOffset. x += screen.x;
    transform.screenOffset.y += screen.y;
}

void main() {
    transform.position = Position;
    transform.screenSize = ScreenSize;
    transform. screenOffset = vec4(0.0);
    
    transform.textureColor = texelFetch(Sampler2, ivec2(UV0 * 256.0), 0);
    
    screenAnchor(254, vec2(10.0, 10.0), 0);
    screenAnchor(253, vec2(-10.0, 10.0), 1);
    screenAnchor(252, vec2(0.0, 10.0), 2);
    screenAnchor(251, vec2(10.0, 0.0), 3);
    screenAnchor(250, vec2(-10.0, 0.0), 4);
    screenAnchor(249, vec2(0.0, 0.0), 5);
    screenAnchor(248, vec2(10.0, -10.0), 6);
    screenAnchor(247, vec2(-10.0, -10.0), 7);
    screenAnchor(246, vec2(0.0, -10.0), 8);
    
    vec3 finalPos = transform.position;
    
    if (transform.screenOffset.x != 0.0 || transform.screenOffset.y != 0.0) {
        finalPos. x += transform.screenOffset.x * (ScreenSize.x / 2.0);
        finalPos.y += transform.screenOffset.y * (ScreenSize.y / 2.0);
    }
    
    gl_Position = ProjMat * ModelViewMat * vec4(finalPos, 1.0);
    
    vertexColor = Color;
    texCoord0 = UV0;
    texColor = transform.textureColor;
}