Shader "Unlit/cartoonShaderBlackPieces"
{
    Properties
    {   
        _shadowIntensity ("Degree of shadow intensity", Range(0,1)) = 0.5 //Defines the ambient light reflecting on the toonshading, with a defualt value of 0.5. 
        _objectIntensity ("Strength of toon shading", Range(0,1)) = 0.5 //Defines the strength of color/texture of the object/toon shader, and it has a default value of 0.5.
        _color ("Set preffered color nuance", Color) = (1, 1, 1, 1) //Allows the user to chose a color nuance to the shader (red, green, blue, alpha)
        _dotDetail ("Detail of the Toon Shading", Range(0,1)) = 0.5 //Amount of detail applied to the toon shader, the default value is set to 0.5
        _MainTex ("Choose Texture", 2D) = "" {} //Controls the texture applied to the object
    }
    SubShader
    {
        name "Toon shader"
        Tags
        {
            
        }

        Pass
        {
            // The pragma keyword tells the compiler that the shader contains two shader functions "vert" and "frag".
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            // #include makes it possible for the shader compiler to takes additional built in functions from Unity.
            #include "UnityCG.cginc"

            //Uniforms sets the controllable settings for the user in Unity, making it possible for the user to make changes.
            //However, in Unity is not required to use uniforms but used for good practice, as other platforms use this syntax.
            uniform float _shadowIntensity;
            uniform float _objectIntensity;
            uniform float _dotDetail;
            uniform float4 _color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            
             

            struct appdata_input //The structure the handles input data
            {
                float4 vertex : POSITION; //The positions of the vertexes of the object.
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;  // The normals in object space, which is later on transformed to world space.
                
            };

            struct vertex_output //The structure handles the output data
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL; //Defines the normals in the vertex shader
            };
            
            
            float toonEffect(float3 directionOfNormal, float3 directionOfLight) //Toon shader function which takes the normal and light direction as arguments.
            {
                // Calculates the dot product by normalizing the normal and light direction vectors.
                // By using the "max" function, then if the dot product < 0,
                // then the calculated dot product would be set to 0.
                float dotProductNL = max(0, dot(normalize(directionOfNormal), normalize(directionOfLight)));
                // By dividing the dot product by a number between "0-1", the less detail will occur in the toon shader,
                // and the floor function rounds down to the closest integer. 
                return floor(dotProductNL/_dotDetail); 
            }
            
            
            //Vertex shader function, which takes an input structure and returns a new struct containing the position of each vertex.
            //In other words, the whole transformation of vertexes happens here. 
            vertex_output vert (appdata_input input) 
            {
                vertex_output output; //Initialize the returning v2f struct called "output".
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                output.vertex = UnityObjectToClipPos(input.vertex); 
                output.worldNormal = UnityObjectToWorldNormal(input.normal); //Takes the normals from the input data, and transform the normals from object space to world space.
                return output;
            }

            fixed4 frag (vertex_output v2f_input) : SV_Target //Fragment shader function, takes the data from the vertex shader function's new structure and uses it to perform the toon shading.
            {
                fixed4 colouring = tex2D(_MainTex, v2f_input.uv);
                colouring *= toonEffect(v2f_input.worldNormal, _WorldSpaceLightPos0.xyz)*(_objectIntensity*_color)+_shadowIntensity;
                return colouring;
            }
            ENDCG
        }
        
        //New shader, it follows the same structure as the first shader.
        /*Pass
        {
            name ""
            
            Tags
            {
                
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            

            
            struct appdata_input
            {
                float4 vertex : POSITION;
            };
            
            struct vertex_output
            {
                float4 vertex : SV_POSITION;
            };
            
            vertex_output vert (appdata_input input)
            {
                vertex_output output;
                return output;
            }
            
            fixed4 frag (vertex_output vertex_input) : SV_Target
            {
                return 
            }
            ENDCG
        }*/
    }
    
}
