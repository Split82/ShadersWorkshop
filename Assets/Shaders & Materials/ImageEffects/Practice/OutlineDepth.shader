Shader "Custom/OutlineDepth"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
        _Sensitivity ("Sensitivity", Float) = 5.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
            float4 _MainTex_TexelSize;            
            sampler2D_float _LastCameraDepthTexture;
            float _Sensitivity;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

                float4 offset = float4(_MainTex_TexelSize.xy, _MainTex_TexelSize.x, -_MainTex_TexelSize.y);
                float d1 = SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv + offset.xy);
                float d2 = SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv - offset.xy);
                float d3 = SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv + offset.zw);
                float d4 = SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv - offset.zw);

                float edge = abs(d1 - d2) + abs(d3 - d4);

                col *= 1.0 - saturate(edge * _Sensitivity);

				return col;
			}
			ENDCG
		}
	}
}
