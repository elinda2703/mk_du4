function [s, d] = uv_sd(u, v, uk, vk)
    %[u,v] -> [s,d], quadrant adjustment

    %Cartographic latitude
    %s in [-pi/2, pi/2]
    arg = sin(u).*sin(uk) + cos(u).*cos(uk).*cos(vk-v);
    s = asin(arg);


    %Cartographic longtitude
    %d in [-pi, pi], quadrant adjustment
    d = -atan2(sin(vk-v).*cos(u), cos(u).*sin(uk).*cos(vk-v) - sin(u).*cos(uk));
end