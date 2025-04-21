
function [Vmin,Vmax,nV,Function] = CostFunction(F)
switch F
    case 'branin'
        Function = @branin;
        nV=2;               % Number of variables (In this case, X1 and X2)
        % Vmin_x1=-5;       % Minimum value for X1
        % Vmax_x1=10;       % Maximum value for X1
        % Vmin_x2=0;        % Minimum value for X2
        % Vmax_x2=15;       % Maximum value for X2
        Vmin = [-5 0];      % Lower bounds of variables
        Vmax = [10 15];     % Upper bounds of variables
        
   % F_min = 0.397887  at (-pi,12.275),(pi,2.275),(9.42478,2.475)  % Goal
end
end


%% Function
% Benchmark Function Name: BRANIN 
function z = branin(xx)
x1 = xx(1);
x2 = xx(2);
if (nargin < 7)
    t = 1 / (8*pi);
end
if (nargin < 6)
    s = 10;
end
if (nargin < 5)
    r = 6;
end
if (nargin < 4)
    c = 5/pi;
end
if (nargin < 3)
    b = 5.1 / (4*pi^2);
end
if (nargin < 2)
    a = 1;
end
term1 = a * (x2 - b*x1^2 + c*x1 - r)^2;
term2 = s*(1-t)*cos(x1);
z = term1 + term2 + s;
end
