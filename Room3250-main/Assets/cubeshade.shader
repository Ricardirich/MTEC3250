Shader "Custom/cubeshade"
{
    Properties
    {
        _Color ("Color", Color) = (1,0,1,0)
        _Color2 ("Color2", Color) = (0,1,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,2)) = 0.0
        _LearpAlpha ("Transition Value", Range(0,1)) = 0
        _Mask1 ("mask 1", 2D) = "white"{}
        _mask2 ("Mask2", 2D) = "Blue"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _Mask1;
        sampler2D _Mask2;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Mask1;
            float2 uv_Mask2;
        };

        half _Glossiness;
        half _Metallic;
        half _LearpAlpha;
        fixed4 _Color;
        fixed4 _Color2;
        fixed4 _ColorAlt;
        fixed4 _Color2Alt;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 cResult1 = lerp(_Color, _Color2, _LearpAlpha);
            fixed4 cResult2 = lerp(_ColorAlt, _Color2Alt, _LearpAlpha);

            fixed4 c1 = tex2D(_MainTex, IN.uv_MainTex) * cResult1;
            fixed4 c2 = tex2D(_MainTex2, IN.uv_MainTex) * cResult2;
            fixed4 m1 = tex2D(_Mask1, IN.uv_Mask1);
            fixed4 m2 = tex2D(_Mask2, IN.uv_Mask2);

            o.Albedo = (c1.rgb + m1.rgb) * (c2.rgb + m2.rgb);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
