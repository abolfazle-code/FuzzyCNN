function [output] = FCLfunction(x,w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%input = sum(x.*w);
input = w*x;
output = sign(input-mean(w));
end

