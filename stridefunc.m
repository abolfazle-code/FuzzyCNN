function [outimg] = stridefunc(inimg,M)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
S = size(inimg);
if numel(S)==2
    output = inimg;
    N1 = 1:S(2);
    N1(1:M:S(2)) = [];
    output(:,N1) = [];
    N2 = 1:S(1);
    N2(1:M:S(1)) = [];
    output(N2,:) = [];
end

if numel(S)==3
    output = inimg;
    N1 = 1:S(2);
    N1(1:M:S(2)) = [];
    output(:,N1,:) = [];
    N2 = 1:S(1);
    N2(1:M:S(1)) = [];
    output(N2,:,:) = [];
end
outimg = output;
end

