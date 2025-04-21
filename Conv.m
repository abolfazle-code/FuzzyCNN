function y = Conv(x, W,numimg)

[wrow, wcol, numFilters] = size(W);
[xrow, xcol, ~         ] = size(x);

y = zeros(xrow, xcol, numFilters,numimg);

for k = 1:numFilters
    %filter = W(:, :, k);
    A = convn(x, W(:, :, k), 'same');
    B = sum(A,3);
    y(:, :, k,:) =B;
end

%y = convn(x,W,'valid');
end
