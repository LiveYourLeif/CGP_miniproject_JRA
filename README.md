# CGP miniproject | Jonas Attrup
## _MED 5 - autumn semester 2022._
This mini-poject was made in order to qualify for the oral esxam in the Computer Graphics Programming coruse at Aalborg University. The foundation of the project is to make a shader, showcase its functionalies in Unity, and understand the basic of HLSL (High-level shader language). In order to do so, a cartoon shader (_Toon shader_) was programmed.

## Instalation instructions
- Clone the git repo or download it manually.
- Open the files with Unity (requires a version that are ≥ 2021.3) 
- Make sure that the textures and 3d-models are present in the assets folder.
- Make sure that the shader materials are placed on a object.


## Contents of Toon Shader
The shader itself is applied to multiple chess pieces on a chess board with the purpose of creating a cartoonish look. The user of the program are presented with different properties, which can be tweaked to the dessired effect through Unity (See _properties_).
The Toon effect is defined with the following function and later applied to the fragtment shader in order to perform the shading:


```c
float toonEffect(float3 directionOfNormal, float3 directionOfLight) 
{
    float diffuseEffect = max(0, dot(normalize(directionOfNormal), normalize(directionOfLight)));
    diffuseEffect = smoothstep(0, 0.1, floor(diffuseEffect/_diffuseAngle)); 
    return diffuseEffect;
}
```
## Properties
All available properties can be manipulated throughout the unity interface, when interacting with the shader materials. The properties can also manually be set within the shader code.
| List of properties | functionality |
| ------ | ------ |
| _diffuseLight| Controls the strength of the diffuse effect. | 
| _color | Multiplies a color nuance to the diffuse effect.| 
| _ambientLight | Controls the amount of ambient light reflecting on the Toon shader. | 
| _lightColor0 | Controls the color which is reflecting on the 3d objetcs from the directional light inside of Unity.| 
| _diffuseAngle | Controls the detail of the Toon Shader.| 
|  _MainTex | Sets the texture which the Toon effect is applied to.| 


## Credits:
### 3d models used:
- "Chess Kit" (https://skfb.ly/6WMyY) by Luke Brown is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
-  "3D Sketchbook - Black Rook" (https://skfb.ly/6Y9AA) by e.shifflett is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
### Textures used:
- "Marble texture" https://polyhaven.com/a/marble_01 by Rob Tuytel is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
### Shaders:
- Wiki books - "Cg Programming/Unity" by (https://en.wikibooks.org/wiki/Cg_Programming/Unity)
- Youtube - "Toon Shader From Scratch - Explained!" by (https://www.youtube.com/watch?v=owwnUcmO3Lw)