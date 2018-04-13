Shader "Custom/ScreenDistortion"
{
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _DistortionTex ("Distortion Texture", 2D) = "black" {}
        _DistortionStrength ("Distortion Strength", Range(0.0, 2.0)) = 1.0
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
        fixed4 color : COLOR;
    };

    struct v2f
    {
        float4 vertex : SV_POSITION;
        fixed4 color : COLOR;
        float2 uv : TEXCOORD;
        float2 uv0 : TEXCOORD1;
        float2 uv1 : TEXCOORD2;
        float4 screenPos : TEXCOORD3;        
    };
    
    sampler2D _ScreenTex;    

    sampler2D _DistortionTex;
    half4 _DistortionTex_ST;

    sampler2D _MainTex;
    half4 _MainTex_ST;

    fixed _Billboard;
    half _DistortionStrength;

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
        
        o.screenPos = ComputeGrabScreenPos(o.vertex);

        o.uv = v.uv;
        o.uv0 = TRANSFORM_TEX(v.uv, _MainTex);        
        o.uv1 = TRANSFORM_TEX(v.uv, _DistortionTex);

        o.color = v.color;  

        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        float2 screenUV = i.screenPos.xy / i.screenPos.w;

        // Distortion offset.
        float2 dist = (tex2D(_DistortionTex, i.uv1).xy - float2(0.5, 0.5)) * _DistortionStrength;
        
        fixed4 c = tex2D(_ScreenTex, screenUV + dist);

        fixed4 m = tex2D(_MainTex, i.uv0);

        c.a *= m.a * i.color.a;
        
        return c;
    }

    ENDCG

	SubShader
	{
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }

         GrabPass { "_ScreenTex" }

		Pass
		{
            Blend [_BlendSrc] [_BlendDst]
            ZWrite Off
            Cull Off

			CGPROGRAM
            #pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
            #pragma shader_feature _BILLBOARD
			ENDCG
		}
	}
}
