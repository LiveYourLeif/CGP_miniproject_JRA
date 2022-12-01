Shader "Unlit/cartoonShaderBlackPieces"
{
     Properties
    {   
        _diffuseLight ("Diffuse effect", Range(0,1)) = 0.5 //Defines how much diffuse effect is applied to  the object, and it has a default value of 0.5. If it is 0, its dark and if it is 1, its vey bright.
        _color ("Set preffered color nuance of the diffuse effect", Color) = (1, 1, 1, 1) //Allows the user to chose a color nuance to the diffuse effect (red, green, blue, alpha)
        _ambientLight ("Degree of shadow intensity", Range(0,1)) = 0.5 //Defines the ambient light reflecting on the shading, with a defualt value of 0.5. If it is 0, the shadows are darker and if it is 1, the shadows are brigther.
        _diffuseAngle ("Detail of the Toon Shading", Range(0,1)) = 0.5 //Amount of detail applied to the toon shader, the default value is set to 0.5. It's based on the angle when the light strikes the surface of the object. 
        _MainTex ("Choose Texture", 2D) = "" {} //Controls the texture applied to the object
        
    }
    SubShader
    {
        name "Toon shader"
        Tags
        {
            "LightMode" = "ForwardBase" // Makes the uniform correspond correctly to Unity
        }

        Pass
        {
            // The pragma keyword tells the compiler that the shader contains two shader functions "vert" and "frag".
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            // #include makes it possible for the shader compiler to takes additional built in functions from Unity.
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            

            //Uniforms sets the controllable settings for the user in Unity, making it possible for the user to make changes.
            //However, in Unity is not required to use uniforms but used for good practice, as other platforms use this syntax.
            uniform float _diffuseLight;
            uniform float4 _color;
            uniform float _ambientLight; 
            uniform float  _diffuseAngle;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            

            struct appdata_input //The structure the handles input data (mesh of the object)
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION; //The positions of the vertexes of the object.
                float3 normal : NORMAL;  // The normals in object space, which is later on transformed to world space, so it can be applied to the fragment shader.
                
            };

            struct vertex_output //The structure handles the output data (mesh of the object)
            {
                float2 uv : TEXCOORD0;
                float4 vertexPos : SV_POSITION;
                float3 normal2World : NORMAL; //Defines the normals in the vertex shader
            };
            
            
            //Vertex shader function, which takes an input structure and returns a new struct containing the position of each vertex.
            //In other words, the whole transformation of vertexes happens here. 
            vertex_output vert (appdata_input input) 
            {
                vertex_output output; //Initialize the returning v2f struct called "output".
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.vertexPos = UnityObjectToClipPos(input.vertex); 
                output.normal2World = UnityObjectToWorldNormal(input.normal); //Takes the normals from the input data, and transform the normals from object space to world space.
                return output;
            }

             float toonEffect(float3 directionOfNormal, float3 directionOfLight) //Toon shader function which takes the normal and light as arguments, and makes the diffuse effect.
            {
                // Calculates the dot product by normalizing the normal and light direction vectors.
                // By using the "max" function, then if the dot product < 0,
                // then the calculated dot product would be clamped to 0.
                float diffuseEffect = max(0, dot(normalize(directionOfNormal), normalize(directionOfLight)));
                // By dividing the diffuse effect by a number between "0-1", the less light will be applied to the object,
                // and the floor function rounds down to the closest integer. In addition, the smoothstep function helps with
                //a more smooth blending between the light and shadows.
                diffuseEffect = smoothstep(0, 1, floor(diffuseEffect / _diffuseAngle));
                return diffuseEffect;
            }

            fixed4 frag (vertex_output v2f_input) : SV_Target //Fragment shader function, takes the data from the vertex shader function's new structure and uses it to perform the toon shading.
            {
                fixed4 object = tex2D(_MainTex, v2f_input.uv);
                //The shading is applied to the object, whereas the different properties are multiplied to the diffuse effect.
                //First the intensity of the diffuse light is applied, as well as a preferred color nuance to the light.
                //Second two types of  light is added, the first being the amount of ambient light, and the second being the in-built color property of Unity's directional light. 
                object *= toonEffect(v2f_input.normal2World, _WorldSpaceLightPos0.xyz)*( _diffuseLight*_color)+(_ambientLight*_LightColor0);
                return object;
            }
            ENDCG
        }
        
        //New shader, it follows the same structure as the first shader.
        /*Pass
        {
            
            name "Outline"
            
            Tags
            {
                
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            uniform float4 _outlineColor;
            uniform float _outlineThickness;
            
            
            struct appdata_input
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            
            struct vertex_output
            {
                float4 vertexPos : SV_POSITION;
                float3 worldNormal : NORMAL;
                float3 directionOfview : TEXCOORD1;
                
               
                
            };

            float outlineEffect(float3 directionOfNormal, float3 directionOfview, float thickness)
            {
                float outlineNormal = (normalize(directionOfNormal), normalize(directionOfview));
                float outlinsmoothning = 1 - dot(directionOfNormal, directionOfview); //Inverting the dot product, 
                return outlineNormal + outlinsmoothning + thickness;
                
            }
            
            vertex_output vert (appdata_input input)
            {
                vertex_output output;
                output.vertexPos = UnityObjectToClipPos(input.vertex);
                output.worldNormal = UnityObjectToWorldNormal(input.normal);
                output.directionOfview = WorldSpaceViewDir(input.vertex);
                return output;
                
            }
            
            fixed4 frag (vertex_output vertex_input) : SV_Target
            {
                float outline = outlineEffect(vertex_input.worldNormal, vertex_input.directionOfview, _outlineThickness);
                return outline + _outlineColor;
            }
            ENDCG
        }*/
    }
}