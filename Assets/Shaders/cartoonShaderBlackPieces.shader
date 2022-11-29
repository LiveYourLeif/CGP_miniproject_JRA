Shader "Unlit/cartoonShaderBlackPieces"
{
     Properties
    {   
        _diffuseLight ("Diffuse effect", Range(0,1)) = 0.5 //Defines the strength of color/texture of the object/toon shader, and it has a default value of 0.5.
        _color ("Set preffered color nuance of the diffuse effect", Color) = (1, 1, 1, 1) //Allows the user to chose a color nuance to the shader (red, green, blue, alpha)
        _ambientLight ("Degree of shadow intensity", Range(0,1)) = 0.5 //Defines the ambient light reflecting on the toonshading, with a defualt value of 0.5. 
        _dotDetail ("Detail of the Toon Shading", Range(0,1)) = 0.5 //Amount of detail applied to the toon shader, the default value is set to 0.5
        _outlineColor("Outline color", Color) = (1, 1, 1, 1)
        _outlineThickness("Outline thickness", Range(0,1)) = 0.5
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
            uniform float _dotDetail;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float4 _outlineColor;
            uniform float _outlineThickness;
            
             

            struct appdata_input //The structure the handles input data
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION; //The positions of the vertexes of the object.
                float3 normal : NORMAL;  // The normals in object space, which is later on transformed to world space.
                
            };

            struct vertex_output //The structure handles the output data
            {
                float2 uv : TEXCOORD0;
                float4 vertexPos : SV_POSITION;
                float3 worldNormal : NORMAL; //Defines the normals in the vertex shader
                float3 viewDirection : TEXCOORD1;
            };
            
            
            float toonEffect(float3 directionOfNormal, float3 directionOfLight, float3 directionOfView) //Toon shader function which takes the normal and light direction as arguments, and makes the diffuse reflection.
            {
                // Calculates the dot product by normalizing the normal and light direction vectors.
                // By using the "max" function, then if the dot product < 0,
                // then the calculated dot product would be set to 0.
                float dotProductNL = max(0, dot(normalize(directionOfNormal), normalize(directionOfLight)));
                // By dividing the dot product by a number between "0-1", the less detail will occur in the toon shader,
                // and the floor function rounds down to the closest integer. In addition, the smoothstep function helps with
                //a more smoothly blending between the light and shadows.
                dotProductNL = smoothstep(0, 0.01, floor(dotProductNL/_dotDetail));
                //The outline
                // float outlineNormal = (normalize(directionOfNormal), normalize(directionOfView));
                // float outlineDotProduct =  1 - dot(directionOfNormal, directionOfView);

                //Return the´toon effect
                return dotProductNL;  // + outlineNormal + outlineDotProduct; 
            }
            
            
            
            //Vertex shader function, which takes an input structure and returns a new struct containing the position of each vertex.
            //In other words, the whole transformation of vertexes happens here. 
            vertex_output vert (appdata_input input) 
            {
                vertex_output output; //Initialize the returning v2f struct called "output".
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.vertexPos = UnityObjectToClipPos(input.vertex); 
                output.worldNormal = UnityObjectToWorldNormal(input.normal); //Takes the normals from the input data, and transform the normals from object space to world space.
                output.viewDirection = WorldSpaceViewDir(input.vertex);
                return output;
            }

            fixed4 frag (vertex_output v2f_input) : SV_Target //Fragment shader function, takes the data from the vertex shader function's new structure and uses it to perform the toon shading.
            {
                fixed4 colouring = tex2D(_MainTex, v2f_input.uv);
                colouring *= toonEffect(v2f_input.worldNormal, _WorldSpaceLightPos0.xyz,v2f_input.viewDirection)*( _diffuseLight*_color)+(_ambientLight*_LightColor0);//*(_outlineColor + _outlineThickness);
                return colouring;
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