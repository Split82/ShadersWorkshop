Shader "Custom/DOF"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
        [HideInInspector] _BlurTex ("Blur Texture", 2D) = "white" {}
        _DepthScale ("Depth Scale", Float) = 0.05
        _DepthOffset ("Offset", Float) = 0.0
	}

    CGINCLUDE 

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
    sampler2D _BlurTex;
    sampler2D_float _LastCameraDepthTexture;
    float _DepthScale;
    float _DepthOffset;

    fixed4 frag (v2f i) : SV_Target
    {
        fixed4 col = tex2D(_MainTex, i.uv);
        fixed4 blurCol = tex2D(_BlurTex, i.uv);

        float depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_LastCameraDepthTexture, i.uv));

        return lerp(col, blurCol, saturate(max(0.0, depth - _DepthOffset) * _DepthScale));
    }

    ENDCG

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag	
			ENDCG
		}   
	}
}
