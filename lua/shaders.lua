


function LoadS()
    myShader = love.graphics.newShader[[
        extern number time;
        
            vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
                
        
        #define iterations 11
        #define formuparam 0.530
        
        #define volsteps 10
        #define stepsize 0.120
        
        #define zoom   0.700
        #define tile   0.950
        #define speed  0.0
        
        #define brightness 0.0035
        #define darkmatter 0.500
        #define distfading 0.660
        #define saturation 0.0020		
                
                    // changed these two lines for lua
                    vec2 uv=screen_coords.xy/love_ScreenSize.xy-.5;
                    uv.y*=love_ScreenSize.y/love_ScreenSize.x;
                    
                    
                    vec3 dir=vec3(uv*zoom,1.);
            
                    float a2=time*speed+.5;
                    float a1=0.0;
                    mat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));
                    mat2 rot2=rot1;//mat2(cos(a2),sin(a2),-sin(a2),cos(a2));
                    dir.xz*=rot1;
                    dir.xy*=rot2;
                    
                    //from.x-=time;
                    //mouse movement
                    vec3 from=vec3(0.,30.,0.78);
                    from+=vec3(.05*time,.02*time,-5.);			
            from.xz*=rot1;
            from.xy*=rot2;
            
            //volumetric rendering
            float s=.1,fade=.2;
            vec3 v=vec3(0.2);
            for (int r=0; r<volsteps; r++) {
                vec3 p=from+s*dir*.9;
                p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
                float pa,a=pa=0.;
                for (int i=0; i<iterations; i++) { 
                    p=abs(p)/dot(p,p)-formuparam; // the magic formula
                    a+=abs(length(p)-pa); // absolute sum of average change
                    pa=length(p);
                }
                float dm=max(0.,darkmatter-a*a*.08); //dark matter
                a*=a*a*2.; // add contrast
                if (r>3) fade*=1.-dm; // dark matter, don't render near
                //v+=vec3(dm*.5,dm*.2,0.);
                v+=fade;
                v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
                fade*=distfading; // distance fading
                s+=stepsize;
            }
            v=mix(vec3(length(v)),v,saturation); //color adjust
            return vec4(v*.017,2.);
        
        
        
                    }
            ]]

            shTest = love.graphics.newShader[[

            float plot(vec2 st, float pct){
              return  smoothstep( pct-0.02, pct, st.y) - 
                      smoothstep( pct, pct+0.02, st.y);
            }
            
            vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            
                vec2 st = gl_FragCoord.xy/love_ScreenSize.xy;
            
                float y = pow(st.x,5.0);
            
                vec3 color2 = vec3(y);
            
                float pct = plot(st,y);
                color2 = (1.0-pct)*color2+pct*vec3(0.0,1.0,0.0);
                
                return vec4(color2,1.0);
            }
                ]]


                idkWhat = love.graphics.newShader[[

                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                        {
                
                        number pW = 1/love_ScreenSize.x;//pixel width 
                        number pH = 1/love_ScreenSize.y;//pixel height
                
                        vec4 pixel = Texel(texture, texture_coords );//This is the current pixel 
                
                        vec2 coords = vec2(texture_coords.x-pW,texture_coords.y);
                        vec4 Lpixel = Texel(texture, coords );//Pixel on the left
                
                        coords = vec2(texture_coords.x+pW,texture_coords.y);
                        vec4 Rpixel = Texel(texture, coords );//Pixel on the right
                
                        coords = vec2(texture_coords.x,texture_coords.y-pH);
                        vec4 Upixel = Texel(texture, coords );//Pixel on the up
                
                        coords = vec2(texture_coords.x,texture_coords.y+pH);
                        vec4 Dpixel = Texel(texture, coords );//Pixel on the down
                
                        pixel.a += 10 * 0.0166667 * (Lpixel.a + Rpixel.a + Dpixel.a * 3 + Upixel.a - 6 * pixel.a);
                
                        pixel.rgb = vec3(1.0,1.0,1.0);
                
                
                        return pixel;
                
                        }
                        ]]
            
end