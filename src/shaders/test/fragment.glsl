#define PI 3.141592653
uniform float uTime;
uniform vec3 uColorA;
uniform vec3 uColorB;
uniform vec2 uResolution;
uniform float uRandom;

varying vec2 vUv;

vec4 permute(vec4 x){
    return mod(((x*34.0)+1.0)*x, 289.0);
}

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson (https://github.com/stegu/webgl-noise)
//
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

float cnoise(vec2 P){
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))* 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid){
    return vec2(
        cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
        cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );

}


// cosine based palette, 4 vec3 params
vec3 palette(float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.283185*(c*t+d) );
}

void main()
{


    // vec2 uv0 = vUv;
    // vec2 uv = vUv;

    // for(float i = 0.0; i < 3.0; i++){

    //     uv = fract(uv * 4.0);
    //     float strength = length(uv - vec2(0.5)) * exp(-length(uv0 - 0.5));


    //     vec3 col = palette(length(uv0 - vec2(0.5)) + i*4. + uTime, a, b, c, d);


    //     strength -= sin(strength * 10.0 + uTime) / 1.0;
    //     strength = abs(strength);

    //     strength = 0.05/strength;

    //     final += col * strength;
    // }

    // gl_FragColor = vec4(final, 1.0);




    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.10, 0.20);


    vec2 uv = gl_FragCoord.xy / uResolution.y;


// *******************************************************************************************

    uv = mod(uv * 30.0, 1.0);
    float rot = cnoise(vUv * 2.0 + uTime * 0.3 );
    vec2 newUv = rotate(uv, rot * PI, vec2(0.5));
    vec2 currUv = newUv * 1.0;

    float x = step(0.55, currUv.x);
    x += step(currUv.x, 0.45);

    x += step(0.9, currUv.y);
    x += step(currUv.y, 0.1);

    // x = 0.01 / x;
    x = 1.0 - x;
    // x= x * exp(x);

    vec3 final = x * palette(rot, a, b, c, d);

    gl_FragColor = vec4(final, 1.0);

// *********************************************************************************************


    // uv = mod(uv * 30.0, 1.0);
    // float circle = length(uv - vec2(0.5));
    // circle = 1.0 - circle;

    // float noise = cnoise(vUv * 1.0 + uTime * 0.1);
    // noise = abs(noise) + 0.1;


    // circle = circle * noise;

    // circle = 0.3 / circle;
    // // circle = circle * exp(circle);
    // vec3 final = circle * palette(circle, a, b, c, d);

    // gl_FragColor = vec4(vec3(circle), 1.0);
    // gl_FragColor = vec4(final, 1.0);

    // gl_FragColor = vec4(gl_FragCoord.xy / 1000.0, 0.0, 1.    0);
}