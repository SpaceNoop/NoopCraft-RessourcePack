#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 markerColor;  // Reçu du vertex shader

out vec4 fragColor;

void main() {
    // Lecture de la texture (comme vanilla)
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    
    // ═══════════════════════════════════════════════════════
    // DÉTECTION ET MASQUAGE DES MARKERS
    // ═══════════════════════════════════════════════════════
    
    // Conversion de la couleur du marker
    float r = markerColor.r * 255.0;
    float g = markerColor.g * 255.0;
    float b = markerColor.b * 255.0;
    float a = markerColor.a * 255.0;
    
    // Un marker a TOUJOURS :  G=255, B=0, R=246-254, A=255
    bool isGreen = (g >= 254.5 && g <= 255.5);
    bool isBlueZero = (b >= -0.5 && b <= 0.5);
    bool isRedMarker = (r >= 245.5 && r <= 254.5);
    bool isOpaque = (a >= 254.5);
    
    // Si c'est un marker, on le masque
    if (isGreen && isBlueZero && isRedMarker && isOpaque) {
        discard;
    }
    
    // Test de transparence (comme vanilla)
    if (color.a < 0.1) {
        discard;
    }
    
    // Application du fog (comme vanilla)
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}