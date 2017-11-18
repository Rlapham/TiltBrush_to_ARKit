Shader "ITP_WORKSHOP/surface_noise_texture" {
	Properties {
		[Header(noise attributes)]
		[Enum(uv,0,normal,1,pos,2)] noise_coordinates ("noise coordinates", Float) = 0
		noise_frequency("frequency", Range(1, 100)) = 1
		noise_movement_dir_x("horizontal direction", Range(-1, 1)) = 0
		noise_movement_dir_y("vertical direction", Range(-1, 1)) = 0
		noise_movement_scale("speed", Range(0, 10)) = 0

		[Header(displacement attributes)]
		[Toggle(enable_displacement)] _enable_displacement("enable displacement", Int) = 0
		displacement_scale("displacement scale", Range(0, 1)) = 0

		[Header(tessellation attributes)]
		[Toggle(enable_tessellation)] _enable_tessellation("enable tessellation", Int) = 0
		tessel_size("tessel size", Range(0, 10)) = 1
		[Space(20)] 

		[Header(default attributes)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert tessellate:tess
		#include "Tessellation.cginc"

		#include "3d_perlin_noise.cginc"

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		#pragma shader_feature enable_displacement
		#pragma shader_feature enable_tessellation

		sampler2D _MainTex;

		struct Input {
			float3 worldPos;
			float3 worldNormal;
			float2 uv_MainTex;
			float noise;
		};

		float noise_frequency;
		float noise_movement_dir_x;
		float noise_movement_dir_y;
		float noise_movement_scale;
		float displacement_scale;
		float tessel_size;
		float noise_coordinates;

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		float4 tess (appdata_full v0, appdata_full v1, appdata_full v2){
			#if enable_tessellation
	            return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, tessel_size);
            #else
            	return float4(1, 1, 1, 1);
            #endif
        }

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void vert(inout appdata_full v){// out Input o){ // <-- when tessellations is on, variable output do not work and throw errors. 
			#if enable_displacement
				float3 noise_movement = float3(_Time.y * -noise_movement_dir_x, _Time.y * -noise_movement_dir_y, 0) * noise_movement_scale;
				float3 noise_uv;
				if(noise_coordinates == 0){
					noise_uv = v.texcoord.xyz;
				} else if (noise_coordinates == 1){
					noise_uv = v.normal.xyz;
				} else {
					noise_uv = v.vertex.xyz;
				}
				float noise = cnoise(noise_uv * noise_frequency + noise_movement);
				float3 displacement = noise * v.normal.xyz * displacement_scale;
				v.vertex.xyz += displacement;
			#endif

			UnityObjectToViewPos(v.vertex);

//			UNITY_INITIALIZE_OUTPUT(Input,o);
//			o.noise = noise;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
//			float noise = IN.noise;

			float3 noise_movement = float3(_Time.y * -noise_movement_dir_x, _Time.y * -noise_movement_dir_y, 0) * noise_movement_scale;
			float3 noise_uv;
			if(noise_coordinates == 0){
				noise_uv = float3(IN.uv_MainTex, 0);
			} else if (noise_coordinates == 1){
				noise_uv = IN.worldNormal;
			} else {
			 	// TODO - fix pos's noise_uv 
				float3 local_pos = IN.worldPos - mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
				noise_uv = local_pos;
			}
			float noise = (cnoise(noise_uv * noise_frequency + noise_movement) + 1.) / 2.;

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * noise;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
