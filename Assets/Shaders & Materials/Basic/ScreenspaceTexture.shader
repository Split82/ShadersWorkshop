Shader "Custom/ScreenspaceTexture"
{

    Properties {

        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
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
        float4 screenPos : TEXCOORD0;
    };

    fixed4 _Color;    
    sampler2D _MainTex;

    v2f vert (appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.screenPos = ComputeScreenPos(o.vertex);
        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        half2 screenUV = i.screenPos.xy / i.screenPos.w;
        fixed4 c = _Color * tex2D(_MainTex, screenUV);
        return c;
    }

    ENDCG    

	SubShader
	{

        Tags { "PreviewType"="Plane" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
}
