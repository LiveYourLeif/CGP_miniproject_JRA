Shader "Unlit/cartoonShaderWhitePieces"
{
    Properties
    {   
        _MainTex ("Texture", 2D) = "" {} //Controls the texture applied to the object. 
        _lightIntensity("Degree of shadow intensity", Range(0,1)) = 0.5 //Defines the ambient light reflecting on the toonshading, with a defualt value of 0.5. 
        _objectIntensity("Strength", Range(0,1)) = 0.5 //Defines the strength of color/texture which is applied to the object/toon shader, and it has a default value of 0.5.
        _dotDetail("Detail of the Toon Shading", Range(0,1)) = 0.5 //Amount of detail applied to the toon shader, the default value is set to 0.5.
    }
    SubShader
    {
        Tags
        {
            "LightMode" = "ForwardBase"
            "PassFlags" = "OnlyDirectional"
        }

        Pass
        {
            // The pragma keyword tells the compiler that the shader contains two shader functions "vert" and "frag".
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            // #include makes it possible for the shader compiler to takes additional built in functions from Unity.
            #include "UnityCG.cginc"

            //Uniforms sets the controllable settings for the user in Unity, makinng it possible for the user to make changes.
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _lightIntensity;
            uniform float _objectIntensity;
            uniform float _dotDetail;

            struct appdata //Appdata handles input data
            {
                float4 vertex : POSITION; //The positions of the vertexes of the object.
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;  // The normals in object space, which is later on transformed to world space.
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL; //Defines the normal in the vertex shader
            };
            
            
            float toonEffect(float3 normal, float3 lightDirection) //Toon shader calculation of dot products
            {
                // The dot product of the normal and light direction are returned and applied later on to the fragment shader
                float NdotL = max(0.0, dot(normalize(normal), normalize(lightDirection))); 
                return floor (NdotL/_dotDetail); 
            }

            v2f vert (appdata v) //Vertex shader function, which takes an appdata structure and returns a struct containing the position of each vertex. 
            {
                v2f o; //Initialize the returning v2f struct called "o".
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal); //Takes the normals from the vf2 structure, and transform the normals from object space to world space.
                return o;
                
            }

            fixed4 frag (v2f i) : SV_Target //Fragment shader function, takes the data from the vertex shader and uses it to perform the shading.
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= toonEffect(i.worldNormal, _WorldSpaceLightPos0.xyz)*_objectIntensity+_lightIntensity;
                return col;
            }
            ENDCG
        }
    }
}
