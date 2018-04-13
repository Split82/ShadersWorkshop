Shader "Custom/BoxBlur"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
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

			fixed4 frag (v2f i) : SV_Target
			{            
                float4 offset = float4(_MainTex_TexelSize.xy, _MainTex_TexelSize.x, -_MainTex_TexelSize.y);
                
                half4 c1 = tex2D(_MainTex, i.uv + offset.xy * 0.5);
                half4 c2 = tex2D(_MainTex, i.uv - offset.xy * 0.5);
                half4 c3 = tex2D(_MainTex, i.uv + offset.zw * 0.5);
                half4 c4 = tex2D(_MainTex, i.uv - offset.zw * 0.5);    

				return (c1 + c2 + c3 + c4) / 4.0;
			}
			ENDCG
		}
	}
}
