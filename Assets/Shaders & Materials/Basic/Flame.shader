Shader "Custom/Flame"
{
    Properties {

        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _DistortionTex ("Distortion Texture", 2D) = "black" {}
        _Color0 ("Color0", Color) = (0.0, 0.0, 0.0, 1.0)
        _Color1 ("Color0", Color) = (1.0, 1.0, 1.0, 1.0)
        _DistortionStrength ("Distortion Strength", Range(0.0, 2.0)) = 1.0
        _Speed ("Speed", Float) = 1.0
        _EdgeHardness ("Edge Hardness", Float) = 10.0
        _EdgeOffset ("Edge Offset", Float) = 0.0
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
        float2 uv : TEXCOORD;
        float2 uv0 : TEXCOORD1;
        float2 uv1 : TEXCOORD2;
    };

    fixed4 _Color0;    
    fixed4 _Color1;    
    sampler2D _NoiseTex;
    half4 _NoiseTex_ST;
    sampler2D _DistortionTex;
    half4 _DistortionTex_ST;
    fixed _Billboard;
    half _DistortionStrength;
    float _Speed;
    half _EdgeHardness;
    half _EdgeOffset;

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
        
        o.uv = v.uv;
        o.uv0 = TRANSFORM_TEX(v.uv, _NoiseTex);
        o.uv1 = TRANSFORM_TEX(v.uv, _DistortionTex);
        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        // Distortion offset.
        float2 dist = (tex2D(_DistortionTex, i.uv1).xy - float2(0.5, 0.5)) * _DistortionStrength;

        // Mask.
        float m = tex2D(_NoiseTex, i.uv0 + dist - float2(0.0, _Time.x * _Speed)).r;

        // Vertical gradient.
        float t = m + (1.0 - i.uv.y);        
        t = saturate((t + _EdgeOffset) * _EdgeHardness * 2 - _EdgeHardness);

        // Color gradient.
        fixed4 c = lerp(_Color1, _Color0, i.uv.y) * t;
        c.a = t;
        return c;
    }

    ENDCG

	SubShader
	{
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }

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
