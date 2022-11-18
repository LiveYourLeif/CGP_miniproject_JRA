Shader "Unlit/cartoonShader"
{
    Properties
    {
        _lightIntensity("Brightness", Range(0,1)) = 0.2 //Defines the brightness reflecting on the toonshading, with a defualt value of 0.2.
        _objectIntensity("Strength", Range(0,1)) = 0.5 //Defines the strength of color which is applied to the object/toon shader, and it has a default valule pf 0.5.
        _dotDetail("Detail of the Toon Shading", Range(0,1)) = 0.5 //Amount of detail applied to the toon shader, the default value is set to 0.5
        _MainTex ("Texture", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            //Uniforms sets the controllable settings for the user in Unity, makinng it possbile for the user to make changes.
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _lighIntensity;
            uniform float _objectIntensity;
            uniform float _dotDetail;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half3 worldNormal : NORMAL;
            };
            
            
            float toonEffect(float3 normal, float3 lightDirection)
            {
                // The * product of the normal and light direction are returned and applied later on to the fragment fucntion
                float NdotL = max(0.0, dot(normalize(normal), normalize(lightDirection)));
                return floor (NdotL/_dotDetail);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                return o;
                
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= toonEffect(i.worldNormal, _WorldSpaceLightPos0.xyz)*_objectIntensity+_lighIntensity;
                return col;
            }
            ENDCG
        }
    }
}
