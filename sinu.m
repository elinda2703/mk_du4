function [x,y] = sinu(R, s, d, s0, d0)
%Mercator-Sanson(sinusoidal)
x = R * d.*cos(s);
y = R * s;