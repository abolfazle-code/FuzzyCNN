function [Wout] = wightingfunc(w,code,num,mn,fism)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%fism = readfis('wightfuzzyTS');
s = (0:(num-1))/(num-1);
S = repmat(s',numel(code),1);
code = code/mn;
C = (code'*ones(1,num))';
C = C(:);
Win = evalfis(fism,[C,S]);
W = (w'*ones(1,num))';
W = W(:);
Wout = 3*cos((W*pi).*Win);
end

