#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;  // Texture du caractère
uniform sampler2D Sampler2;  // Lightmap

uniform vec2 ScreenSize;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 markerColor;  // Couleur du marker

struct Transform {
    vec4 textureColor;
    vec3 position;
    vec4 screenOffset;
} transform;

void screenAnchor(int marker, vec2 offset, int anchor) {
    // Extraction de la valeur du marker depuis le canal rouge
    int detectedMarker = int(transform.textureColor.r * 255.0 + 0.5);
    
    if (detectedMarker != marker) {
        return;
    }
    
    vec2 screen;
    
    switch(anchor) {
        case 0:  // TOP_LEFT
            screen = vec2(-1.0, 2.0);
            break;
        case 1:  // TOP_RIGHT
            screen = vec2(1.0, 2.0);
            break;
        case 2:  // TOP_CENTER
            screen = vec2(0.0, 2.0);
            break;
        case 3:  // MIDDLE_LEFT
            screen = vec2(-1.0, 1.0);
            break;
        case 4:  // MIDDLE_RIGHT
            screen = vec2(1.0, 1.0);
            break;
        case 5:  // MIDDLE_CENTER
            screen = vec2(0.0, 1.0);
            break;
        case 6:  // BOTTOM_LEFT
            screen = vec2(-1.0, 0.0);
            break;
        case 7:  // BOTTOM_RIGHT
            screen = vec2(1.0, 0.0);
            break;
        case 8:  // BOTTOM_CENTER
            screen = vec2(0.0, 0.0);
            break;
        default:
            return;
    }
    
    transform.position.x += offset.x;
    transform.position.y += offset.y;
    transform.screenOffset.x += screen.x;
    transform.screenOffset.y += screen.y;
}

void main() {
    // Initialisation
    transform.position = Position;
    transform.screenOffset = vec4(0.0);
    
    // ═══════════════════════════════════════════════════════
    // LECTURE DE LA COULEUR DU MARKER depuis Sampler0 ! 
    // ═══════════════════════════════════════════════════════
    
    // On lit la couleur MOYENNE de la texture du caractère
    // Pour un marker (1x1 pixel), ça donne directement la couleur RGBA
    transform.textureColor = texture(Sampler0, UV0);
    
    // Test des 9 markers
    screenAnchor(254, vec2(10.0, 10.0), 0);   // TOP_LEFT
    screenAnchor(253, vec2(-10.0, 10.0), 1);  // TOP_RIGHT
    screenAnchor(252, vec2(0.0, 10.0), 2);    // TOP_CENTER
    screenAnchor(251, vec2(10.0, 0.0), 3);    // MIDDLE_LEFT
    screenAnchor(250, vec2(-10.0, 0.0), 4);   // MIDDLE_RIGHT
    screenAnchor(249, vec2(0.0, 0.0), 5);     // MIDDLE_CENTER
    screenAnchor(248, vec2(10.0, -10.0), 6);  // BOTTOM_LEFT
    screenAnchor(247, vec2(-10.0, -10.0), 7); // BOTTOM_RIGHT
    screenAnchor(246, vec2(0.0, -10.0), 8);   // BOTTOM_CENTER
    
    // Application du screenOffset
    vec3 finalPos = transform.position;
    
    if (transform.screenOffset.x != 0.0 || transform.screenOffset.y != 0.0) {
        finalPos.x += transform.screenOffset.x * (ScreenSize.x / 2.0);
        finalPos.y += transform.screenOffset.y * (ScreenSize.y / 2.0);
    }
    
    // Transformation finale (comme vanilla)
    gl_Position = ProjMat * ModelViewMat * vec4(finalPos, 1.0);
    
    // Calcul du fog (comme vanilla)
    sphericalVertexDistance = fog_spherical_distance(finalPos);
    cylindricalVertexDistance = fog_cylindrical_distance(finalPos);
    
    // Couleur avec lightmap (comme vanilla)
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    
    // Coordonnées de texture
    texCoord0 = UV0;
    
    // Transmission de la couleur du marker au fragment shader
    markerColor = transform.textureColor;
}