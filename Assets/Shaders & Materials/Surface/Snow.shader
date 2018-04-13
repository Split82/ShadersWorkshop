Shader "Custom/Snow" {

	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SnowCap ("Snow Cap", Range(0,0.3)) = 0.1
        _EdgeHardness ("Edge Hardness", Float) = 5.0
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}

    CGINCLUDE

    sampler2D _MainTex;

    struct Input {
        float2 uv_MainTex;
        float3 worldNormal;
    };

    half _Glossiness;
    half _Metallic;
    half _SnowCap;
    half _EdgeHardness;
    fixed4 _Color;

    void surf (Input IN, inout SurfaceOutputStandard o) {

        // Albedo comes from a texture tinted by color
        fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
        float t = dot(IN.worldNormal, float3(0.0, 1.0, 0.0));
        t = saturate(t * _EdgeHardness * 2.0 - _EdgeHardness + (_SnowCap - 0.5) * _EdgeHardness * 2);
        o.Albedo = lerp(c.rgb, fixed3(1.0, 1.0, 1.0), t);

        // Metallic and smoothness come from slider variables
        o.Metallic = _Metallic;
        o.Smoothness = _Glossiness;
        
        o.Alpha = c.a;
    }

    ENDCG

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		ENDCG
	}
	FallBack "Diffuse"
}