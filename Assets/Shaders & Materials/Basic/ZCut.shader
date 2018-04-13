Shader "Custom/ZCut"
{

    Properties {

        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }

    CGINCLUDE
    
    #include "UnityCG.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        half3 normal : NORMAL;
    };

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float4 worldPos : TEXCOORD0;
        fixed4 color : COLOR;
    };

    fixed4 _Color;			

    v2f vert (appdata v)
    {
        v2f o;
        o.color = dot(ObjSpaceLightDir(v.vertex), v.normal);
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        return o;
    }
    
    fixed4 frag (v2f i) : SV_Target
    {
        clip(i.worldPos.z);
        return _Color * i.color;
    }

    ENDCG    

	SubShader
	{
		Pass
		{
            Cull off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
}
