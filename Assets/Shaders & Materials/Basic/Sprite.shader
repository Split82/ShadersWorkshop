Shader "Custom/Sprite"
{
    Properties {

        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        [Toggle(_BILLBOARD)] _Billboard ("Billboard", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst", Float) = 1
    }

    CGINCLUDE
    
    #include "UnityCG.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD;
    };

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float2 uv : TEXCOORD0;
    };

    fixed4 _Color;    
    sampler2D _MainTex;
    half4 _MainTex_ST;
    fixed _Billboard;

    v2f vert (appdata v)
    {
        v2f o;

        #if _BILLBOARD
            // Billboard
            float4 vpos = float4(UnityObjectToViewPos(float3(0.0, 0.0, 0.0)), 1.0);
            vpos.xy += v.vertex.xy;
            o.vertex = mul(UNITY_MATRIX_P, vpos);                       
        #else
            o.vertex = UnityObjectToClipPos(v.vertex);             
        #endif

        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        fixed4 c = _Color * tex2D(_MainTex, i.uv);
        return c;
    }

    ENDCG

	SubShader
	{
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "PreviewType"="Plane" }

		Pass
		{
            Blend [_BlendSrc] [_BlendDst]
            ZWrite Off
            Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma shader_feature _BILLBOARD
			ENDCG
		}
	}
}
